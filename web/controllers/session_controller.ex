defmodule Rumbl.SessionController do
    user Rumbl.Web, :controller


    @doc """
    Renderira stranicu /sessions/new.

    ## Parametri

    - `conn` - konekcija
    """
    def new(conn, _) do
        render(conn, "new.html")
    end
end