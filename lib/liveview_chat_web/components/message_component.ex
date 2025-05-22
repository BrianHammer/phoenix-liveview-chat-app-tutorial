defmodule LiveviewChatWeb.MessageComponent do
  use Phoenix.Component
  import LiveviewChatWeb.CoreComponents

  def message(assigns) do
    ~H"""
    <ul id="msg-list" phx-update="append">
      <%= for message <- @messages do %>
        <li id={"msg-#{message.id}"}>
          <b>{message.name}:</b>
          {message.message}
        </li>
      <% end %>
    </ul>

    <.form for={@form} id="form" phx-submit="new_message" phx-change="changed" phx-hook="Form">
      <.input field={@form[:name]} type="text" id="name" placeholder="Your name" autofocus />

      <.input field={@form[:message]} type="text" id="msg" placeholder="Your message" />

      <button type="submit" class="...">Send</button>
    </.form>
    """
  end
end
