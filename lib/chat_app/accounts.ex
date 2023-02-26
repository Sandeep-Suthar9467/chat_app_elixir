defmodule ChatApp.Accounts do
  alias ChatApp.Repo
  alias ChatApp.Accounts.User

  def sign_in(email, password) do

    user = Repo.get_by(User, email: email)
    IO.inspect(user)

    # check = Bcrypt.check_pass(password, user.password_hash)
    # IO.inspect(check)
    IO.inspect(password)

    cond do
      user && Bcrypt.check_pass(password, user.password_hash) ->
        {:ok, user}
      true ->
        {:error, :unauthorized}
    end
  end

    def user_signed_in?(conn), do: !!current_user(conn)

    def current_user(conn) do
      user_id = Plug.Conn.get_session(conn, :current_user_id)
      if user_id, do: Repo.get(User, user_id)
    end


   def sign_out(conn) do
     Plug.Conn.configure_session(conn, drop: true)
   end

   def register(params) do
     result = User.registration_changeset(%User{}, params) |> Repo.insert()
     IO.inspect(result)
   end


end
