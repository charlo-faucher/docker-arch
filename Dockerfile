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

RUN git clone https://github.com/charlo-faucher/dotfiles.git --recursive

RUN cd /home/${USERNAME}/dotfiles
RUN if [ -f dotfiles/install.sh ]; then sudo bash dotfiles/install.sh; fi;

ENTRYPOINT ["/bin/bash", "-c", "/home/$USERNAME/dotfiles/link.sh"]
CMD ["zsh", "-l"]
