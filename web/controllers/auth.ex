defmodule Rumbl.Auth do
@moduledoc """
Ovo je authentication plug.

Ovaj modul definira `Rumbl.Auth` struct.
"""
    import Plug.Conn
    import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
    import Phoenix.Controller
    
    alias Rumbl.Router.Helpers

    @doc """
    Inicijalizira repozitorij iz danog spremnika opcija tražeći `repo` u
    tom spremniku. Ako repozitorij ne postoji onda dođe do exceptiona.

    ## Parametri

    - `opts` - set opcija

    """
    def init(opts) do
        Keyword.fetch!(opts, :repo)
    end



    @doc """
    Modificira konekciju tako da doda `current_user` u nju.

    Provjerava se da li je `user_id` iz repozitorija dobivenog od `init/1`
    spremljen u session. Ako je onda se modificira konekcija.

    ## Parametri

    - `conn` - konekcija

    - `repo` -  repozitorij dobiven od `init/1` funkcije
    """
    def call(conn, repo) do
        user_id = get_session(conn, :user_id)
        user    = user_id && repo.get(Rumbl.User, user_id)
        assign(conn, :current_user, user)
    end



    @doc """
    Sprema user ID u session.

    ## Parametri

    - `conn` - konekcija

    - `user` - trenutni korisnik
    """
    def login(conn, user) do
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
    end



    @doc """
    Odlogira korisnika tako da dropa session.

    ## Parametri

    - `conn` - konekcija
    """
    def logout(conn) do
        Plug.Conn.configure_session(conn, drop: true)
    end
    
    
    @doc """
    Provjerava da li se dani `username` i `given_pass` nalaze u repozitoriju.
    Ako da onda se poziva `login/2` da se podesi session. Ako se `username`
    nalazi u repozitoriju ali ne i `given_pass` onda se vrati `unauthorized`.
    Ako `user` nije pronađen onda se vrati `error`.

    ## Parametri

    - `conn` - konekcija

    - `username` - username koji korisnik unese

    - `given_pass` - password koji korisnik unese

    - `opts` - opcije
    """
    def login_by_username_and_pass(conn, username, given_pass, opts) do
        repo = Keyword.fetch!(opts, :repo)
        user = repo.get_by(Rumbl.User, username: username)
        # nađi prvi koji je true
        cond do
            user && checkpw(given_pass, user.password_hash) ->
                {:ok, login(conn, user)}
            user ->
                {:error, :unauthorized, conn}
            true ->
                dummy_checkpw()
                {:error, :not_found, conn} 
        end
    end



    @doc """
    Provjerava da li je konekcija authenticated za trenutnog korisnika.
    
    Ako je konekcija authenticated za trenutnog korisnika onda se ništa ne desi,
    a ako nije authenticated onda se otvori index stranica sa porukom da se ne
    može pristupiti traženoj stranici dok se korisnik ne ulogira.

    ## Parametri

    - `conn` - konekcija
    """
    def authenticate_user(conn, _opts) do
        if conn.assigns[:current_user] do
            conn
        else
            conn
            |> put_flash(:error, "You must be logged in to access this page.")
            |> redirect(to: Helpers.page_path(conn, :index))
            |> halt()    
        end
    end
end