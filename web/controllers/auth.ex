defmodule Rumbl.Auth do
@moduledoc """
Ovo je authentication plug.

Ovaj modul definira `Rumbl.Auth` struct.
"""
    import Plug.Conn

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
        conn = assign(conn, :current_user, user)
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
    Provjerava da li se dani `username` i `given_pass` nalaze u repozitoriju.
    Ako da onda se poziva `login/2`, a ako ne onda je `error`.

    ## Parametri

    - `conn` - konekcija

    - `username` - username koji korisnik unese

    - `given_pass` - password koji korisnik unese

    - `opts` - opcije
    """
    def login_by_username_and_pass(conn, username, given_pass, opts) do
        repo = Keyword.fetch!(conn, :repo)
        user = repo.get_by(Repo.User, username: username)
        # nađi prvi koji je true
        cond do
            user && checkpw(given_pass, user[:password_hash]) ->
                {:ok, login(conn, user)}
            user ->
                {:error, :unauthorized, conn}
            true ->
                dummy_checkpw()
                {:error, :not_found, conn} 
            
        end
    end
end