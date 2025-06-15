# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

# Library specifics
export ANDROID_HOME=$HOME/Android/Sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export CHROME_EXECUTABLE=/usr/bin/chromium
export QT_MEDIA_BACKEND=gstreamer

# Path
export PATH=$PATH:$ANDROID_HOME/platform-tools:$HOME/flutter/flutter/bin:$HOME/.pub-cache/bin:$HOME/.dotnet/tools:$HOME/.config/composer/vendor/bin:$HOME/.local/share/gem/ruby/3.4.0/bin

# Aliases
alias ls="ls -a"
# Fix discord screencast not working by using web version
alias discord2='chromium --enable=features=Use0zonePLatform --ozone-platform=wayland --enable-features=WebRTCPipeWireCapturer --app=https://discord.com/app'
# Desktop nvidia custom setting
alias nvidiapoor='sudo nvidia-smi -pl 100'
# Webcam specific
alias webcam='gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -f v4l2 /dev/video0'
alias servehtml='python -m http.server 8081'
alias servephp='php -S localhost:8081'

# NVM
source /usr/share/nvm/init-nvm.sh

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Zoxide
eval "$(zoxide init zsh)"
