defmodule Rumbl.Auth do
@moduledoc """
Ovo je authentication plug.

Ovaj modul definira `Rumbl.Auth` struct.
"""
    import Plug.Conn

    @doc """
    Uzme dane opcije vadeći repozitorij iz spremnika. Ako repozitorij ne postoji
    onda dođe do exceptiona.
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
end