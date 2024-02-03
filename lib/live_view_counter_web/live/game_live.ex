defmodule LiveViewCounterWeb.GameLive do
  use LiveViewCounterWeb, :live_view

  def mount(_params, _session, socket) do
    {question, correct_answer} = new_question();
    socket = socket
    |> assign(question: question)
    |> assign(correct_answer: correct_answer)
    |> assign(score: 0)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <p><%= @question %></p>
      <form phx-submit="submit">
        <input type="text" name="answer" phx-model="answer" />
        <.button type="submit">Submit</.button>
      </form>
      <p>Score: <%= @score %></p>
    </div>
    """
  end

  def handle_event("submit", %{"answer" => answer}, socket) do
    {question, correct_answer} = new_question()
    if String.to_integer(answer) == socket.assigns.correct_answer do
      {:noreply, assign(
        socket
        |> assign(question: question)
        |> assign(correct_answer: correct_answer),
        score: socket.assigns.score + 1)}
    else
      {:noreply, socket
      |> assign(question: question)
      |> assign(correct_answer: correct_answer)
    }
    end
  end

  defp new_question do
    num1 = Enum.random(1..10)
    num2 = Enum.random(1..10)
    correct_answer = num1 + num2
    {"#{num1} + #{num2} = ?", correct_answer}
  end
end
