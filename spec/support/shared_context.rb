shared_context "tv shows" do
  let(:input) do
    [
      {
        title: "The Walking Dead",
        channel: "AMC",
        watchers: 1337,
        status: "running",
        cast: ["Lincoln, Andrew", "McBride, Melissa"],
        ratings: {
          imdb: 8.7,
          trakt: 89,
          rotten_tomatoes: 93,
        },
      },
      {
        title: "Breaking Bad",
        channel: "AMC",
        watchers: 72891,
        status: "ended",
        cast: ["Cranston, Bryan", "Gunn, Anna"],
        ratings: {
          imdb: 9.5,
          trakt: 95,
          rotten_tomatoes: 100,
        },
      }
    ]
  end

  let(:single_input) do
    input.first
  end
end
