defmodule Rumbl.SessionController do
    use Rumbl.Web, :controller


    @doc """
    Renderira stranicu /sessions/new.

    ## Parametri

    - `conn` - konekcija
    """
    def new(conn, _) do
        render(conn, "new.html")
    end

    @doc """
    Create akcija uzme `username` i `password` i ulogira na ispravno unesene podatke.
    Ako login ne uspije onda se renderira /session/new
    """
    def create(conn, %{"session"=> %{"username"=> user, "password"=> pass}}) do
        case Rumbl.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
            {ok: conn} ->
                conn
                |> put_flash(:info, "Welcome back!")
                |> redirect(to: page_path(conn, :index))
            {error: _reason, conn} ->
                conn
                |> put_flash(:error, "Ivalid username/password combination.")
                |> render("new.html")
        end
    end
end