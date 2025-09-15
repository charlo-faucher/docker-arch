FROM archlinux:latest

# System update only (no extras — dotfiles will handle packages)
RUN pacman -Syu --noconfirm && pacman -Scc --noconfirm

# Environment variables (overridden by docker-compose .env)
ENV USERNAME=user \
    PASSWORD=password \
    TIMEZONE=UTC \
    HOSTNAME=arch-docker \
    DOTFILES_REPO=""

# Timezone (fallback safe)
RUN ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime || true

# Create user
RUN useradd -m -s /bin/bash $USERNAME \
    && echo "$USERNAME:$PASSWORD" | chpasswd

# Set hostname
RUN echo "$HOSTNAME" > /etc/hostname

# Switch to user
USER $USERNAME
WORKDIR /home/$USERNAME

# Clone and run dotfiles bootstrap if provided
RUN if [ ! -z "$DOTFILES_REPO" ]; then \
      pacman -Sy --noconfirm git && \
      git clone --recursive "$DOTFILES_REPO" /home/$USERNAME/.dotfiles && \
      cd /home/$USERNAME/.dotfiles && \
      if [ -f install.sh ]; then bash install.sh; fi; \
    fi
