defmodule Rumbl.UserController do
    use Rumbl.Web, :controller

    alias Rumbl.User


    def index(conn, _params) do
        case authenticate(conn) do
            %Plug.Conn{halted: true} = conn ->
                conn
            conn ->
                users = Repo.all(Rumbl.User)
                render(conn, "index.html", users: users)
        end
    end



    def show(conn, %{"id" => id}) do
        case authenticate(conn) do
            %Plug.Conn{halted: true} = conn ->
                conn
            conn ->
                user = Repo.get(Rumbl.User, id)
                render(conn, "index.html", user: user)
        end
    end

    def new(conn, _params) do
        case authenticate(conn) do
            %Plug.Conn{halted: true} = conn ->
                    conn
            conn ->
                changeset = User.changeset(%User{})
                render(conn, "new.html", changeset: changeset)
        end
    end


    @doc """
    Kreira novog Usera u bazi. Ako su uneseni podaci ok onda je unos u bazu izvršen
    te se otvara stranica sa svim korisnicima u bazi. Ako uneseni podaci nisu ok onda
    se ne ostvari unos novog korisnika i pojavi se poruka da do unosa nije došlo.

    ## Parametri

    - conn - konekcija

    - user_params - `user_params` je mapa dobivena za pattern match sa "user"
    """
    def create(conn, %{"user" => user_params}) do
        changeset = User.registration_changeset(%User{}, user_params)

        case Repo.insert(changeset) do
            {:ok, user} ->
                conn
                |> put_flash(:info, "#{user.name} created!")
                |> redirect(to: user_path(conn, :index))
            {:error, changeset} ->
                render(conn, "new.html", changeset: changeset)
        end
    end



    @doc """
    Provjerava da li je konekcija authenticated za trenutnog korisnika.
    
    Ako je konekcija authenticated za trenutnog korisnika onda se ništa ne desi,
    a ako nije authenticated onda se otvori index stranica sa porukom da se ne
    može pristupiti traženoj stranici dok se korisnik ne ulogira.

    ## Parametri

    - conn - konekcija
    """
    defp authenticate(conn) do
        if conn.assigns[:current_user] do
            conn
        else
            conn
            |> put_flash(:error, "You must be logged in to access this page.")
            |> redirect(to: page_path(conn, :index))
            |> halt()    
        end
    end
end