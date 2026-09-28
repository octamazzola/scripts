# Scripts de Utilidad

Colección de scripts para automatización y optimización.

---

## 🚀 Optimización para Linux Mint (Máquinas viejas / HDD)

Script diseñado para mejorar el rendimiento en laptops y PCs con procesadores antiguos (ej. Intel Core i5 3ra Gen), 4GB a 8GB de RAM y discos rígidos mecánicos (HDD).

### ¿Qué hace?
- Desactiva animaciones y efectos pesados de Cinnamon.
- Instala `preload` (precarga programas frecuentes en RAM).
- Instala `zram-tools` (comprime memoria en RAM para evitar congelamientos de disco).
- Instala drivers de video de Intel con aceleración por hardware (`i965-va-driver`, `intel-media-va-driver`).
- Configura `vm.swappiness=10` para minimizar el uso de swap en el HDD.
- Agrega la opción `noatime` en `/etc/fstab` para evitar escrituras y demoras innecesarias al leer archivos.
- Realiza limpieza de paquetes huérfanos y caché del sistema.

### ⚡ Ejecución directa (un solo comando)

Abre la terminal en Linux Mint (`Ctrl + Alt + T`) y ejecuta:

```bash
curl -sSL https://raw.githubusercontent.com/octamazzola/scripts/main/optimizar_mint.sh | bash
```

O si prefieres clonar el repositorio:

```bash
git clone https://github.com/octamazzola/scripts.git
cd scripts
chmod +x optimizar_mint.sh
./optimizar_mint.sh
```
