defmodule LiveViewCounterWeb.CounterLive do
  use LiveViewCounterWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0, form: to_form(%{"increment_by" => 2}))}
  end

  def render(assigns) do
    ~H"""
    <h1>Counter</h1>
    <p class="mt-2 bg-yellow-100">Count: <%= @count %></p>
    <.button id="increment-button" phx-click="increment" class="mt-3">Increment</.button>
    <.simple_form id="increment-form" for={@form} phx-change="change" phx-submit="increment_by">
      <.input type="number" field={@form[:increment_by]} label="Increment Count"/>
      <:actions>
        <.button>Increment By</.button>
      </:actions>
    </.simple_form>
    """
  end

  def handle_event("increment", _, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end

  def handle_event("change", params, socket) do
    IO.inspect(params)
    socket =
      case Integer.parse(params["increment_by"]) do
        :error -> assign(socket, form: to_form(params, errors: [increment_by: "Must be a valid integer"]))
        _ -> assign(socket, form: to_form(params))
      end
    {:noreply, socket}
  end

  def handle_event("increment_by", params, socket) do
    socket =
      case Integer.parse(params["increment_by"]) do
        :error -> assign(socket, form: to_form(params, errors: [increment_by: "Must be a valid integer"]))
        {int, _res} -> assign(socket, count: socket.assigns.count + int)
      end
    {:noreply, socket}
  end
end
