let os = (sys host | get name)

# install dependencies
match $os {
  "Darwin" => {
    brew install carapace
  },
  "Windows" => {
    winget install -e --id rsteube.Carapace
  },
  _ => {
    echo "unsupported OS: " + $os
    exit 1
  }
}
