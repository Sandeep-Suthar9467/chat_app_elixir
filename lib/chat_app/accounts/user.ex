defmodule ChatApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChatApp.Accounts.User

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :username, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :rooms, ChatApp.Talk.Room
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password_hash])
    |> validate_required([:email, :username])
    |> validate_length(:username, min: 5, max: 12)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  def registration_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> validate_confirmation(:password)
    |> cast(attrs, [:password], [])
    |> validate_length(:password, min: 6, max: 100)
    |> encrypt_password()
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
