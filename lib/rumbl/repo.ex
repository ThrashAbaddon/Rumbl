defmodule Rumbl.Repo do
    @moduledoc """
    In memory repository.
    """
  #use Ecto.Repo, otp_app: :rumbl

  def all(Rumbl.User) do
      [
          %Rumbl.User{id: "1", name: "José", username: "josevalim", password: "elixir"},
          %Rumbl.User{id: "2", name: "Bruce", username: "redrapids", password: "7langs"},
          %Rumbl.User{id: "3", name: "Chris", username: "chrismccord", password: "phx"}
      ]
  end

  def get(module, id) do
      Enum.find(all(module), fn(map) -> map.id == id end)
  end

    #ovo grozno izgleda
    # todo razlomi ovo na privatne funkcije
    def get_by(module, params) do
        Enum.find(all(module), fn(map) ->
            Enum.all?(params, fn({key, value}) -> Map.get(map,key) == value end)
        end)
    end

end
