defmodule ChatApp.Talk.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    # field :room_id, :id
    # field :user_id, :id
    belongs_to :room, ChatApp.Talk.Room
    belongs_to :user, ChatApp.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
