defmodule Rumbl.UserController do
    use Rumbl.Web, :controller

    alias Rumbl.User


    def index(conn, _params) do
        # ´Repo.all´ fetches all entries from the data store matching the given query
        users = Repo.all(Rumbl.User)
        render(conn, "index.html", users: users)
    end

    def show(conn, %{"id" => id}) do
        # `Repo.get` fetches a single struct from the data store where the primary key matches the given id.
        user = Repo.get(Rumbl.User, id)
        render(conn, "show.html", user: user)
    end

    def new(conn, _params) do
        changeset = User.changeset(%User{})
        render(conn, "new.html", changeset: changeset)
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
end