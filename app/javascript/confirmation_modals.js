// Sistema de Modais de Confirmação
console.log('Confirmation modals script loaded');

function initializeConfirmationModals() {
  console.log('Initializing confirmation modals');
  
  // Interceptar evento turbo:before-fetch-request para confirmações
  document.addEventListener('turbo:before-fetch-request', function(event) {
    const element = event.target;
    const confirmMessage = element.dataset.confirm || element.getAttribute('data-confirm');
    
    if (confirmMessage && !element.dataset.confirmed) {
      event.preventDefault();
      
      // Determinar tipo de ação
      const isDelete = element.dataset.turboMethod === 'delete' || 
                       element.getAttribute('data-turbo-method') === 'delete';
      const type = isDelete ? 'danger' : 'warning';
      const title = isDelete ? 'Confirmar Exclusão' : 'Confirmar Alterações';
      
      showConfirmationModal(
        title,
        confirmMessage,
        type,
        function() {
          element.dataset.confirmed = 'true';
          element.click();
        }
      );
    }
  }, { capture: true });
  
  // Interceptar submissão de formulários
  document.querySelectorAll('form').forEach(form => {
    if (form.dataset.confirmListenerAdded) return;
    form.dataset.confirmListenerAdded = 'true';
    
    form.addEventListener('submit', function(e) {
      const submitButton = form.querySelector('input[type="submit"][data-confirm]');
      const confirmMessage = submitButton?.dataset.confirm;
      
      if (confirmMessage && !form.dataset.confirmed) {
        e.preventDefault();
        e.stopImmediatePropagation();
        
        showConfirmationModal(
          'Confirmar Alterações',
          confirmMessage,
          'warning',
          function() {
            form.dataset.confirmed = 'true';
            form.requestSubmit();
          }
        );
      }
    }, { capture: true });
  });
}

// Inicializar
document.addEventListener('DOMContentLoaded', initializeConfirmationModals);
document.addEventListener('turbo:load', initializeConfirmationModals);

function showConfirmationModal(title, message, type, onConfirm) {
  // Criar overlay
  const overlay = document.createElement('div');
  overlay.className = 'modal-overlay active';
  overlay.id = 'confirmation-overlay';
  
  // Criar modal
  const modal = document.createElement('div');
  modal.className = 'confirmation-modal';
  
  // Ícone baseado no tipo
  const icon = type === 'danger' ? '🗑️' : '⚠️';
  
  modal.innerHTML = `
    <div class="modal-header">
      <span class="modal-icon ${type}">${icon}</span>
      <h3 class="modal-title">${title}</h3>
    </div>
    <div class="modal-body">
      <p>${message}</p>
    </div>
    <div class="modal-actions">
      <button class="btn btn-secondary" onclick="closeConfirmationModal()">Cancelar</button>
      <button class="btn btn-${type}" id="confirm-action-btn">Confirmar</button>
    </div>
  `;
  
  overlay.appendChild(modal);
  document.body.appendChild(overlay);
  
  // Adicionar event listener ao botão de confirmar
  document.getElementById('confirm-action-btn').addEventListener('click', function() {
    closeConfirmationModal();
    if (onConfirm) onConfirm();
  });
  
  // Fechar ao clicar no overlay
  overlay.addEventListener('click', function(e) {
    if (e.target === overlay) {
      closeConfirmationModal();
    }
  });
  
  // Fechar com ESC
  document.addEventListener('keydown', function escHandler(e) {
    if (e.key === 'Escape') {
      closeConfirmationModal();
      document.removeEventListener('keydown', escHandler);
    }
  });
}

function closeConfirmationModal() {
  const overlay = document.getElementById('confirmation-overlay');
  if (overlay) {
    overlay.classList.remove('active');
    setTimeout(() => overlay.remove(), 200);
  }
}

// Expor funções globalmente
window.showConfirmationModal = showConfirmationModal;
window.closeConfirmationModal = closeConfirmationModal;
