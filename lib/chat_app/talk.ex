defmodule ChatApp.Talk do
  alias ChatApp.Talk.Message
  alias ChatApp.Repo
  alias ChatApp.Talk.Room

  import Ecto.Query

  def create_message(user, room, attrs \\ %{}) do
    user
      |> Ecto.build_assoc(:messages, room_id: room.id)
      |> Message.changeset(attrs)
      |> Repo.insert()
  end

  def list_messages(room_id, limit \\ 20) do
    # Repo.all(
    #   from msg in Message,
    #   join: user in assoc(msg, :user),
    #   where: msg.room_id == ^room_id,
    #   order_by: [desc: msg.inserted_at],
    #   limit: ^limit,
    #   select: %{body: msg.body, user: %{username: user.username}}
    # )
    query =
      from msg in Message,
        join: user in assoc(msg, :user),
        where: msg.room_id == ^room_id,
        order_by: [desc: msg.inserted_at],
        limit: ^limit

    Repo.all(
      from [msg, user] in query,
        select: %{body: msg.body, user: %{username: user.username}}
    )
  end
  def list_rooms do
    Repo.all(Room)
  end

  def change_room(%Room{} =room) do
    Room.changeset(room, %{})
  end
  def create_room(user, attrs \\ %{}) do
    user
      |> Ecto.build_assoc(:rooms)
      |> Room.changeset(attrs)
      |> Repo.insert()

  end
  def update_room(%Room{} = room, attrs) do
    room
      |> Room.changeset(attrs)
      |> Repo.update()
  end
  def delete_room(%Room{} = room) do
    room |> Repo.delete()
  end
  def get_room!(id), do: Repo.get!(Room, id)
end
