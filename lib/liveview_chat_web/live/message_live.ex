defmodule LiveviewChatWeb.MessageLive do
  alias LiveviewChatWeb.MessageComponent
  use LiveviewChatWeb, :live_view

  alias LiveviewChat.Message

  def mount(_p, _session, socket) do
    if connected?(socket), do: Message.subscribe()

    messages = Message.list_messages() |> Enum.reverse()
    form = %Message{} |> Message.changeset(%{}) |> to_form()

    {:ok, socket |> assign(form: form, messages: messages), temporary_assigns: [messages: []]}
  end

  @spec handle_event(<<_::88>>, map(), any()) :: {:noreply, any()}
  def handle_event("new_message", %{"message" => params}, socket) do
    case Message.create_message(params) do
      {:error, changeset} ->
        {:noreply, assign(socket, form: changeset |> to_form())}

      :ok ->
        form =
          %Message{} |> Message.changeset(%{message: "", name: ""}) |> to_form()

        {:noreply, assign(socket, form: form)}
    end
  end

  def handle_event("changed", %{"message" => params}, socket) do
    new_form =
      %Message{}
      |> Message.changeset(%{message: params[:message], name: params[:name]})
      |> to_form()

    {:noreply, assign(socket, form: new_form)}
  end

  def handle_info({:message_created, message}, socket) do
    {:noreply, socket |> assign(messages: [message])}
  end

  def render(assigns) do
    ~H"""
    <MessageComponent.message messages={@messages} form={@form} />
    """
  end
end
