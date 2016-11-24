defmodule Rumbl.UserController do
    use Rumbl.Web, :controller

    # index akcija
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
end