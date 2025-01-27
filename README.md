# Music Mood Matcher

Music Mood Matcher is a music recommendation service that suggests music based on the mood of the user. It leverages advanced natural language processing and music streaming APIs to provide personalized music recommendations.

## Features

- **Mood Analysis**: Connects to Hugging Face to call the RoBERTa API to parse the user's feelings.
- **Music Recommendations**: Connects to the Spotify API to send the inference and present music recommendations.
- **Interactive Links**: Provides clickable links to send the user directly to Spotify.

## How It Works

1. **User Input**: The user inputs their current mood or feelings.
2. **Mood Parsing**: The input is sent to the RoBERTa API via Hugging Face to analyze and understand the user's mood.
3. **Music Recommendation**: Based on the parsed mood, the service connects to the Spotify API to fetch music recommendations.
4. **Interactive Experience**: The recommended music is presented with clickable links that take the user to Spotify.

## Setup

To set up the project locally, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/music-mood-matcher.git
   cd music-mood-matcher
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Set up environment variables for Hugging Face and Spotify API keys.

4. Run the application:

   ```bash
   flutter run
   ```

## Usage

1. Open the application with your preffered medium.
2. Enter your current mood or feelings in the input box.
3. Press the enter button.
4. Browse through the recommended music and click on the links to listen on Spotify.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Hugging Face](https://huggingface.co/) for providing the RoBERTa API.
- [Spotify](https://www.spotify.com/) for the music streaming API.

Enjoy your personalized music experience with Music Mood Matcher!
