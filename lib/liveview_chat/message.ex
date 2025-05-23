defmodule LiveviewChat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias LiveviewChat.Repo
  alias __MODULE__

  alias Phoenix.PubSub

  def subscribe() do
    PubSub.subscribe(LiveviewChat.PubSub, "liveview_chat")
  end

  def notify({:ok, message}, event) do
    PubSub.broadcast(LiveviewChat.PubSub, "liveview_chat", {event, message})
  end

  def notify({:error, reason}, _event), do: {:error, reason}

  schema "messages" do
    field :message, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :message])
    |> validate_required([:name, :message])
    |> validate_length(:message, min: 3)
  end

  def create_message(attrs) do
    %Message{}
    |> changeset(attrs)
    |> Repo.insert()
    |> notify(:message_created)
  end

  def list_messages do
    Message
    |> limit(20)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end
end
