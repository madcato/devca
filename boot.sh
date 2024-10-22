set -e

ascii_art='    .___                         
  __| _/_______  __ ____ _____   
 / __ |/ __ \  \/ // ___\\__  \  
/ /_/ \  ___/\   /\  \___ / __ \_
\____ |\___  >\_/  \___  >____  /
     \/    \/          \/     \/ 
'

echo -e "$ascii_art"
echo "=> devca is for Ubuntu or macOS installations only!"
echo -e "\nBegin installation (or abort with ctrl+c)..."

echo "Cloning devca repository..."
rm -rf ~/.local/share/devca
git clone https://github.com/madcato/devca.git ~/.local/share/devca >/dev/null
if [[ $DEVAC_REF != "master" ]]; then
	cd ~/.local/share/devca
	git fetch origin "${DEVAC_REF:-stable}" && git checkout "${DEVAC_REF:-stable}"
	cd -
fi

echo "Installation starting..."
source ~/.local/share/omyserv/install.sh 