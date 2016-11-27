defmodule Rumbl.UserController do
    use Rumbl.Web, :controller

    import Rumbl.Auth, only: [authenticate_user: 2]

    plug :authenticate_user when action in [:index, :show]

    alias Rumbl.User

    @doc """
    Prikazuje sve korisnike koji se nalaze u spremniku podataka.

    ## Parametri

    - `conn` - konekcija
    """
    def index(conn, _params) do
        users = Repo.all(Rumbl.User)
        render(conn, "index.html", users: users)
    end


    @doc """
    Prikazuje jednog korisnika izabirući ga po njegovom id-u iz spremnika
    podataka.

    ## Parametri

    - `conn` - konekcija

    - `id` - `id` pokazuje na vrijednost u danoj mapi, tj. na `id` usera
    """
    def show(conn, %{"id" => id}) do
        user = Repo.get(Rumbl.User, id)
        render(conn, "show.html", user: user)
    end

    @doc """
    Kreira novoga korisnika u spremniku podataka.

    ## Parametri

    - `conn` - konekcija
    """
    def new(conn, _params) do
        changeset = User.changeset(%User{})
        render(conn, "new.html", changeset: changeset)
    end


    @doc """
    Kreira novog Usera u bazi. Ako su uneseni podaci ok onda je unos u bazu izvršen
    te se otvara stranica sa svim korisnicima u bazi. Ako uneseni podaci nisu ok onda
    se ne ostvari unos novog korisnika i pojavi se poruka da do unosa nije došlo.

    ## Parametri

    - `conn` - konekcija

    - `user_params` - je podmapa dobivena za pattern match sa "user"
    """
    def create(conn, %{"user" => user_params}) do
        changeset = User.registration_changeset(%User{}, user_params)

        case Repo.insert(changeset) do
            {:ok, user} ->
                conn
                |> Rumbl.Auth.login(user)
                |> put_flash(:info, "#{user.name} created!")
                |> redirect(to: user_path(conn, :index))
            {:error, changeset} ->
                render(conn, "new.html", changeset: changeset)
        end
    end
end