FROM archlinux:latest

RUN pacman -Syu --noconfirm && pacman -Scc --noconfirm

ARG USERNAME=user
ARG PASSWORD=password
ARG TIMEZONE=UTC
ARG HOSTNAME=arch-docker

ENV USERNAME=${USERNAME} \
    PASSWORD=${PASSWORD} \
    TIMEZONE=${TIMEZONE} \
    HOSTNAME=${HOSTNAME}

# Timezone (fallback safe)
RUN ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime || true

# Create user
RUN useradd -m -s /bin/bash $USERNAME \
    && echo "$USERNAME:$PASSWORD" | chpasswd

RUN pacman -Sy --noconfirm sudo git zsh \
    && echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && usermod -aG wheel ${USERNAME} \
    && pacman -Scc --noconfirm

# Set hostname
RUN echo "$HOSTNAME" > /etc/hostname

# Switch to user
USER $USERNAME
WORKDIR /home/$USERNAME

COPY dotfiles /home/${USERNAME}/dotfiles
RUN ls -al
RUN cd /home/${USERNAME}/dotfiles && \
    if [ -f install.sh ]; then sudo bash install.sh; fi;

ENTRYPOINT ["/home/${USERNAME}/link.sh"]
CMD ["zsh", "-l"]
