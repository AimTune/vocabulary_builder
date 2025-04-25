defmodule VocabularyBuilderWeb.KanbanLive do
  use VocabularyBuilderWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      backlog: ["test1", "test2"],
      daily: ["test3"],
      weekly: []
    )}
  end

  def handle_event("add_word", %{"list" => list, "word" => word}, socket) do
    list_atom = String.to_atom(list)
    current_list = Map.get(socket.assigns, list_atom)
    updated_list = current_list ++ [word]

    {:noreply, assign(socket, list_atom, updated_list)}
  end

  def handle_event("phx:move_word", %{"from" => from, "to" => to, "word" => word}, socket) do
    IO.inspect({"Moving word", word, "from", from, "to", to}, label: "DEBUG")

    from_list = String.to_atom(from)
    to_list = String.to_atom(to)

    current_from = Map.get(socket.assigns, from_list)
    current_to = Map.get(socket.assigns, to_list)

    updated_from = Enum.reject(current_from, &(&1 == word))
    updated_to = current_to ++ [word]

    socket =
      socket
      |> assign(from_list, updated_from)
      |> assign(to_list, updated_to)

    IO.inspect({"Updated state", socket.assigns}, label: "DEBUG")
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex gap-8 p-8 h-screen bg-gray-900" id="kanban" phx-hook="Kanban">
      <div class="flex-1 bg-gray-800 rounded-xl shadow-lg overflow-hidden" data-list="backlog">
        <div class="bg-gray-700 px-6 py-4">
          <h2 class="text-xl font-bold text-white">Backlog</h2>
        </div>
        <div class="p-6">
          <div class="flex-1 space-y-3 overflow-y-auto border-2 border-dashed border-gray-600/50 rounded-lg p-4 min-h-[200px]" phx-drop-target="backlog">
            <%= for word <- @backlog do %>
              <div
                draggable="true"
                data-word={word}
                data-list="backlog"
                class="bg-gray-700 px-4 py-3 rounded-lg shadow-sm text-white cursor-move hover:bg-gray-600 transition-colors"
              >
                <%= word %>
              </div>
            <% end %>
          </div>
          <form phx-submit="add_word" class="mt-6 flex gap-2">
            <input type="hidden" name="list" value="backlog">
            <input
              type="text"
              name="word"
              class="flex-1 bg-gray-700 border-0 rounded-lg px-4 py-2 text-white placeholder-gray-400 focus:ring-2 focus:ring-blue-500"
              placeholder="Add new word"
            >
            <button type="submit" class="bg-blue-500 text-white px-6 py-2 rounded-lg hover:bg-blue-600 transition-colors">Add</button>
          </form>
        </div>
      </div>

      <div class="flex-1 bg-gray-800 rounded-xl shadow-lg overflow-hidden" data-list="daily">
        <div class="bg-gray-700 px-6 py-4">
          <h2 class="text-xl font-bold text-white">Daily</h2>
        </div>
        <div class="p-6">
          <div class="flex-1 space-y-3 overflow-y-auto border-2 border-dashed border-gray-600/50 rounded-lg p-4 min-h-[200px]" phx-drop-target="daily">
            <%= for word <- @daily do %>
              <div
                draggable="true"
                data-word={word}
                data-list="daily"
                class="bg-gray-700 px-4 py-3 rounded-lg shadow-sm text-white cursor-move hover:bg-gray-600 transition-colors"
              >
                <%= word %>
              </div>
            <% end %>
          </div>
        </div>
      </div>

      <div class="flex-1 bg-gray-800 rounded-xl shadow-lg overflow-hidden" data-list="weekly">
        <div class="bg-gray-700 px-6 py-4">
          <h2 class="text-xl font-bold text-white">Weekly</h2>
        </div>
        <div class="p-6">
          <div class="flex-1 space-y-3 overflow-y-auto border-2 border-dashed border-gray-600/50 rounded-lg p-4 min-h-[200px]" phx-drop-target="weekly">
            <%= for word <- @weekly do %>
              <div
                draggable="true"
                data-word={word}
                data-list="weekly"
                class="bg-gray-700 px-4 py-3 rounded-lg shadow-sm text-white cursor-move hover:bg-gray-600 transition-colors"
              >
                <%= word %>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
