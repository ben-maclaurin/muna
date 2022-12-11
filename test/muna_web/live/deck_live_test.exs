defmodule MunaWeb.DeckLiveTest do
  use MunaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Muna.StudyFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_deck(_) do
    deck = deck_fixture()
    %{deck: deck}
  end

  describe "Index" do
    setup [:create_deck]

    test "lists all decks", %{conn: conn, deck: deck} do
      {:ok, _index_live, html} = live(conn, ~p"/decks")

      assert html =~ "Listing Decks"
      assert html =~ deck.name
    end

    test "saves new deck", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/decks")

      assert index_live |> element("a", "New Deck") |> render_click() =~
               "New Deck"

      assert_patch(index_live, ~p"/decks/new")

      assert index_live
             |> form("#deck-form", deck: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#deck-form", deck: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/decks")

      assert html =~ "Deck created successfully"
      assert html =~ "some name"
    end

    test "updates deck in listing", %{conn: conn, deck: deck} do
      {:ok, index_live, _html} = live(conn, ~p"/decks")

      assert index_live |> element("#decks-#{deck.id} a", "Edit") |> render_click() =~
               "Edit Deck"

      assert_patch(index_live, ~p"/decks/#{deck}/edit")

      assert index_live
             |> form("#deck-form", deck: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#deck-form", deck: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/decks")

      assert html =~ "Deck updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes deck in listing", %{conn: conn, deck: deck} do
      {:ok, index_live, _html} = live(conn, ~p"/decks")

      assert index_live |> element("#decks-#{deck.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#deck-#{deck.id}")
    end
  end

  describe "Show" do
    setup [:create_deck]

    test "displays deck", %{conn: conn, deck: deck} do
      {:ok, _show_live, html} = live(conn, ~p"/decks/#{deck}")

      assert html =~ "Show Deck"
      assert html =~ deck.name
    end

    test "updates deck within modal", %{conn: conn, deck: deck} do
      {:ok, show_live, _html} = live(conn, ~p"/decks/#{deck}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Deck"

      assert_patch(show_live, ~p"/decks/#{deck}/show/edit")

      assert show_live
             |> form("#deck-form", deck: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#deck-form", deck: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/decks/#{deck}")

      assert html =~ "Deck updated successfully"
      assert html =~ "some updated name"
    end
  end
end
