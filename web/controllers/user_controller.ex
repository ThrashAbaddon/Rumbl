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


    def create(conn, %{"user" => user_params}) do
        changeset = User.changeset(%User{}, user_params)
        {:ok, user} = Repo.insert(changeset)

        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_parh(conn, :index))
    end
end