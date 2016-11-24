defmodule Rumbl.UserView do
    use Rumbl.Web, :view
    alias Rumbl.User


    @doc """
    Parse the user's first name from the user's name field.

    ## Parameters

    - `user` - A User struct

    ## Examples

        alias Rumbl.UserView
        alias Rumbl.User
        user = %User{name: "Bruce Gruce"}
        UserView.first_name(user)
        "Bruce"
    """
    def first_name(%User{name: name}) do
        name
        |> String.split(" ")
        |> Enum.at(0)
    end


    @doc """
    Parse the user's last name from the user's name field.

    ## Parameters

    - `user` - A User struct

    ## Examples

        alias Rumbl.UserView
        alias Rumbl.User
        user = %User{name: "Bruce Gruce"}
        UserView.last_name(user)
        "Gruce"
    """
    def last_name(%User{name: name}) do
        name
        |> String.split(" ")
        |> Enum.at(1)
    end
end