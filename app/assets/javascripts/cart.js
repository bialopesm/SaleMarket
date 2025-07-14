document.addEventListener('DOMContentLoaded', function() {
  // Função para mostrar notificações
  function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} notification`;
    notification.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      z-index: 9999;
      min-width: 300px;
      animation: slideIn 0.3s ease-out;
    `;
    notification.innerHTML = `
      <i class="bi bi-${type === 'success' ? 'check-circle' : 'exclamation-circle'} me-2"></i>
      ${message}
    `;
    document.body.appendChild(notification);
    setTimeout(() => {
      notification.style.animation = 'slideOut 0.3s ease-in';
      setTimeout(() => {
        if (notification.parentNode) {
          notification.parentNode.removeChild(notification);
        }
      }, 300);
    }, 3000);
  }

  // Atualizar só o carrinho
  function updateCart() {
    fetch(window.location.pathname)
      .then(response => response.text())
      .then(html => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        const newCart = doc.querySelector('.cart-section');
        const currentCart = document.querySelector('.cart-section');
        if (newCart && currentCart) {
          currentCart.innerHTML = newCart.innerHTML;
        }
      });
  }

  // Interceptar submit do adicionar ao carrinho
  document.addEventListener('submit', function(e) {
    if (e.target.action && e.target.action.includes('add_item')) {
      e.preventDefault();
      const form = e.target;
      const button = form.querySelector('button[type="submit"]');
      const originalText = button.innerHTML;
      button.innerHTML = '<i class="bi bi-hourglass-split me-2"></i> Adicionando...';
      button.disabled = true;
      const formData = new FormData(form);
      fetch(form.action, {
        method: 'POST',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: formData
      })
      .then(response => {
        if (response.ok) {
          showNotification('Produto adicionado ao carrinho!', 'success');
          updateCart();
        } else {
          showNotification('Erro ao adicionar produto', 'danger');
        }
      })
      .catch(error => {
        showNotification('Erro ao adicionar produto', 'danger');
      })
      .finally(() => {
        button.innerHTML = originalText;
        button.disabled = false;
      });
    }
  });

  // Remover produto do carrinho
  document.addEventListener('click', function(e) {
    if (e.target.closest('form') && e.target.closest('form').action && e.target.closest('form').action.includes('remove_item')) {
      e.preventDefault();

      const form = e.target.closest('form');
      const button = e.target.closest('button');
      const originalText = button.innerHTML;

      // Mostrar loading
      button.innerHTML = '<i class="bi bi-hourglass-split me-1"></i> Removendo...';
      button.disabled = true;

      fetch(form.action, {
        method: 'DELETE',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          showNotification(data.message, 'success');
          updateCart(data);
        } else {
          showNotification('Erro ao remover produto', 'danger');
        }
      })
      .catch(error => {
        console.error('Erro:', error);
        showNotification('Erro ao remover produto', 'danger');
      })
      .finally(() => {
        // Restaurar botão
        button.innerHTML = originalText;
        button.disabled = false;
      });
    }
  });

  // Esvaziar carrinho
  document.addEventListener('click', function(e) {
    if (e.target.closest('form') && e.target.closest('form').action && e.target.closest('form').action.includes('empty_cart')) {
      e.preventDefault();

      const form = e.target.closest('form');
      const button = e.target.closest('button');
      const originalText = button.innerHTML;

      if (confirm('Tem certeza que quer esvaziar o carrinho?')) {
        // Mostrar loading
        button.innerHTML = '<i class="bi bi-hourglass-split me-1"></i> Esvaziando...';
        button.disabled = true;

        fetch(form.action, {
          method: 'DELETE',
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          }
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            showNotification(data.message, 'success');
            updateCart(data);
          } else {
            showNotification('Erro ao esvaziar carrinho', 'danger');
          }
        })
        .catch(error => {
          console.error('Erro:', error);
          showNotification('Erro ao esvaziar carrinho', 'danger');
        })
        .finally(() => {
          // Restaurar botão
          button.innerHTML = originalText;
          button.disabled = false;
        });
      }
    }
  });
});

// Adicionar estilos CSS para as animações
const style = document.createElement('style');
style.textContent = `
  @keyframes slideIn {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }

  @keyframes slideOut {
    from {
      transform: translateX(0);
      opacity: 1;
    }
    to {
      transform: translateX(100%);
      opacity: 0;
    }
  }
`;
document.head.appendChild(style);
