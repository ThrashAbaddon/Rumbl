defmodule Rumbl.User do
    use Rumbl.Web, :model

    schema "users" do
        field :name,            :string
        field :username,        :string
        field :password,        :string, virtual: true
        field :password_hash,   :string

        timestamps
    end

    @doc """
    Provjerava da li User struct sadrži `name` i `username` te da li `username` 
    odgovara duljini od 1 do 20 znakova. Opcionalnih polja nema.

    ## Parametri

    - `model` - to je User struct
    
    - `params` - opcionalni parametri, ali nije poznato još kakvi točno.
    """
    def changeset(model, params \\ :empty) do
        model
        |> cast(params, ~w(name username), [])
        |> validate_length(:username, min: 1, max: 20)
    end
end
