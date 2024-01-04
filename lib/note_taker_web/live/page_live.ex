defmodule NoteTaker.PageLive do
  use NoteTakerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(NoteTaker.PubSub, "bot_update")
    {:ok, assign(socket, messages: [])}
  end

  @impl true
  def handle_info({:update, update}, socket) do
    {:noreply, assign(socket, messages: [to_message(update) | socket.assigns.messages])}
  end

  defp to_message(%{"message" => message} = _update) do
    firstname = get_in(message, ["from", "first_name"])
    lastname = get_in(message, ["from", "last_name"])
    username = get_in(message, ["from", "username"])

    from =
      case {firstname, lastname, username} do
        {nil, _, username} -> username
        {firstname, nil, _} -> firstname
        {firstname, lastname, _} -> "#{firstname} #{lastname}"
      end

    text = get_in(message, ["text"])
    %{from: from, text: text}
  end
end