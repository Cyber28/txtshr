defmodule TxtshrWeb.PageLive do
  use TxtshrWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      randstr = Txtshr.random_string()
      :ets.insert(:stuff, {randstr, self()})
      {:ok, assign(socket, msgs: [], code: randstr, loaded: true)}
    else
      {:ok, assign(socket, msgs: [], code: "", loaded: false)}
    end
  end

  @impl true
  def handle_event("submit", %{"code" => code, "txt" => txt}, socket) do
    case :ets.lookup(:stuff, code) do
      [{_, pid}] ->
        send(pid, {:msg, txt})
        {:noreply, push_event(socket, "toast", %{type: "success", msg: "Sent"})}

      _ ->
        {:noreply, push_event(socket, "toast", %{type: "error", msg: "Code not found"})}
    end
  end

  @impl true
  def handle_info({:msg, txt}, socket) do
    {:noreply, assign(socket, msgs: [txt | socket.assigns.msgs])}
  end
end
