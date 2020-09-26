defmodule TxtshrWeb.PageLive do
  use TxtshrWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      randstr = Txtshr.random_string(6)
      :ets.insert(:stuff, {randstr, self()})
      {:ok, assign(socket, msgs: [], code: randstr)}
    else
      {:ok, assign(socket, msgs: [], code: "")}
    end
  end

  @impl true
  def handle_event("submit", %{"code" => code, "txt" => txt}, socket) do
    case :ets.lookup(:stuff, code) do
      [{_, pid}] ->
        send(pid, {:msg, txt})
        {:noreply, put_flash(socket, :info, "sent")}

      _ ->
        {:noreply, put_flash(socket, :error, "code not found")}
    end
  end

  @impl true
  def handle_info({:msg, txt}, socket) do
    {:noreply, assign(socket, msgs: [txt | socket.assigns.msgs])}
  end
end
