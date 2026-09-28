#!/bin/bash
set -e

# Colores para la salida
VERDE='\033[1;32m'
AZUL='\033[1;34m'
AMARILLO='\033[1;33m'
RESET='\033[0m'

echo -e "${AZUL}====================================================${RESET}"
echo -e "${AZUL}   OPTIMIZADOR PARA LINUX MINT (Banghó i5 / HDD)   ${RESET}"
echo -e "${AZUL}====================================================${RESET}"

# 1. Comprobar permisos sudo
sudo -v

# 2. Desactivar efectos visuales de Cinnamon (a nivel de usuario)
echo -e "\n${AMARILLO}[1/6] Desactivando animaciones y efectos de escritorio...${RESET}"
if command -v gsettings &>/dev/null; then
    gsettings set org.cinnamon enable-animations false 2>/dev/null || true
    gsettings set org.cinnamon.desktop.interface enable-animations false 2>/dev/null || true
    echo -e "${VERDE}✔ Efectos de ventanas desactivados.${RESET}"
fi

# 3. Actualizar repositorios e instalar paquetes de aceleración
echo -e "\n${AMARILLO}[2/6] Instalando preload, zram y drivers de video Intel...${RESET}"
sudo apt update -y
sudo apt install -y preload zram-tools i965-va-driver intel-media-va-driver lm-sensors
echo -e "${VERDE}✔ Paquetes instalados correctamente.${RESET}"

# 4. Configurar Swappiness a 10
echo -e "\n${AMARILLO}[3/6] Configurando agresividad de Swap (swappiness=10)...${RESET}"
if ! grep -q "vm.swappiness" /etc/sysctl.conf; then
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
else
    sudo sed -i 's/^vm.swappiness=.*/vm.swappiness=10/' /etc/sysctl.conf
fi
sudo sysctl -p
echo -e "${VERDE}✔ Swappiness fijado en 10 (protege el HDD de congelamientos).${RESET}"

# 5. Optimizar lectura de disco (noatime en fstab)
echo -e "\n${AMARILLO}[4/6] Optimizando accesos al disco HDD (/etc/fstab)...${RESET}"
if ! grep -E '[[:space:]]/[[:space:]]ext4' /etc/fstab | grep -q "noatime"; then
    sudo cp /etc/fstab /etc/fstab.bak_$(date +%s)
    sudo sed -i '/[[:space:]]\/[[:space:]]ext4/ s/errors=remount-ro/errors=remount-ro,noatime/' /etc/fstab
    sudo sed -i '/[[:space:]]\/[[:space:]]ext4/ s/defaults/defaults,noatime/' /etc/fstab
    echo -e "${VERDE}✔ Opción 'noatime' agregada a la partición raíz.${RESET}"
else
    echo -e "${VERDE}✔ 'noatime' ya estaba configurado.${RESET}"
fi

# 6. Limpieza de paquetes huérfanos y caché
echo -e "\n${AMARILLO}[5/6] Limpiando paquetes residuales y caché...${RESET}"
sudo apt autoremove --purge -y
sudo apt clean
echo -e "${VERDE}✔ Sistema limpio.${RESET}"

# 7. Resumen y reinicio
echo -e "\n${AZUL}====================================================${RESET}"
echo -e "${VERDE}¡OPTIMIZACIÓN COMPLETADA CON ÉXITO!${RESET}"
echo -e "${AZUL}====================================================${RESET}"
echo -e "Recomendaciones finales para el navegador web:"
echo -e " 1. Extensión 'enhanced-h264ify' (bloquear VP9 y AV1 para usar la GPU)."
echo -e " 2. Extensión 'uBlock Origin'."
echo -e " 3. Extensión 'Auto Tab Discard'."
echo -e "\n${AMARILLO}Es necesario reiniciar la máquina para aplicar los cambios en disco y RAM.${RESET}"

if [ -t 0 ] || [ -e /dev/tty ]; then
    read -p "¿Deseas reiniciar el equipo ahora mismo? (s/n): " RESP < /dev/tty 2>/dev/null || RESP="n"
    if [[ "$RESP" =~ ^[sS]$ ]]; then
        echo "Reiniciando..."
        sudo reboot
    else
        echo "Recuerda reiniciar manualmente cuando puedas."
    fi
else
    echo "Por favor, reinicia tu equipo manualmente (sudo reboot) para aplicar los cambios."
fi
