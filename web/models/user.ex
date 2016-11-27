defmodule Rumbl.User do
    use Rumbl.Web, :model

    schema "users" do
        field    :name,            :string
        field    :username,        :string
        field    :password,        :string, virtual: true
        field    :password_hash,   :string
        has_many :videos,           Rumbl.Video

        timestamps
    end

    @doc """
    Provjerava da li User struct sadrži `name` i `username` koji odgovaraju 
    duljini od 1 do 20 znakova. Opcionalnih polja nema.

    ## Parametri

    - `model` - to je User struct
    
    - `params` - opcionalni parametri, ali nije poznato još kakvi točno.
    """
    def changeset(model, params \\ %{}) do
        model
        |> cast(params, ~w(name username), [])
        |> validate_length(:name, min: 1, max: 20)
        |> validate_length(:username, min: 1, max: 20)
    end

    @doc """
    
    """
    def registration_changeset(model, params) do
        model
        |> changeset(params)
        |> cast(params, ~w(password), [])
        |> validate_length(:password, min: 6, max: 100)
        |> _put_pass_hash()
    end

    @doc """
    Funkcija koje izvršava password hashing u changesetu.
    Vrši se provjera da li je changeset validan te ako je onda se rezultat
    stavlja u changeset kao `password_hash` koristeći bcrypt algoritam. Ako
    changeset nije validan onda se on samo vrati nazad.
    """
    defp _put_pass_hash(changeset) do
        case changeset do
            %Ecto.Changeset{valid?: true, changes: %{password: pass}}  ->
                put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
                
            _  ->
                changeset
        end
    end
end
