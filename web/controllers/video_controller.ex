defmodule Rumbl.VideoController do
  use Rumbl.Web, :controller

  # sanitiziranje praznih HTML formi iz "" u nil
  plug :scrub_params, "video" when action in [:create, :update]

  alias Rumbl.Video

  @doc """
  Akcija koja renderira stranicu i prikaže sve videe od određenog usera.
  """
  def index(conn, _params, user) do
    videos = Repo.all(user_videos(user))
    # IO.inspect videos
    render(conn, "index.html", videos: videos)
  end

  @doc """
  Kreira novi info o videu u spremniku podataka.
  Za spremanje videa koristi se informacija o `current_user`
  u konekciji tako da postoji informacija tko je spremio video
  u spremnik podataka.
  """
  def new(conn, _params) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:videos) # wut
      |> Video.changeset()    # wut
    IO.inspect changeset
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}) do
    changeset = 
      conn.assigns.current_user
      |> build_assoc(:videos)
      |> Video.changeset(video_params)

    case Repo.insert(changeset) do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    video = Repo.get!(user_videos(user), id)
    # IO.inspect video
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = Repo.get!(user_videos(user), id)
    changeset = Video.changeset(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Repo.get!(user_videos(user), id)
    changeset = Video.changeset(video, video_params)

    case Repo.update(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    video = Repo.get!(user_videos(user), id)
    Repo.delete!(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  @doc """
  Funkcija koristi `assoc/2` funkciju da vrati upit svih videa koji su povezani
  sa danim `user`om.
  """
  defp user_videos(user) do
    assoc(user, :videos)
  end


  # @doc """
  
  # """
  # def action(conn, _) do
  #   apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  # end
end
