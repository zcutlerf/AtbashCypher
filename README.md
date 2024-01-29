# Atbash Cypher

Implementation of the Atbash Cypher for latin alphabetic characters:
* Encodes a message into an Atbash encrypted message.
  * Removes punctuation and whitespace.
  * Reverses latin alphabetic characters (A becomes Z, B becomes Y, etc).
  * Leaves numerals and non-latin letters as-is.
  * Converts to lowercase.
  * After every 5 characters, adds one space.
* Decodes an Atbash encrypted message into a forward-facing string.
  * Removes whitespace.
  * Reverses latin alphabetic characters (A becomes Z, B becomes Y, etc).
* Attempts to turn messy decoded message (no spaces or punctuation) into an English-readable message, using OpenAI's API chat completion. 

More info about the cypher: https://en.wikipedia.org/wiki/Atbash

What I learned:
* Using `URLProtocol` to create my own `URLSession` to test the behavior of a service based on specific HTTP responses.
* Using integration tests to test the actual behavior of a service contacting an API.
* Creating a `HTTPService` protocol to create complex URLRequests in a type-safe way, and streamline code in actual services.
