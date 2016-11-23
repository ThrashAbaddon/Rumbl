defmodule Rumbl.UserController do
    use Rumbl.Web, :controller

    # jedina akcija je index
    def index(conn, _params) do
        # ´Repo.all´ fetches all entries from the data store matching the given query
        users = Repo.all(Rumbl.User)
        render(conn, "index.html", users: users)
    end
end