// Sistema de Modais de Confirmação

// Interceptar submissão de formulários (incluindo button_to)
document.addEventListener('submit', function(e) {
  const form = e.target;
  
  // Verificar se o formulário ou botão tem data-confirm
  const confirmMessage = form.dataset.confirm || 
                        form.querySelector('[data-confirm]')?.dataset.confirm ||
                        form.querySelector('button[data-confirm]')?.dataset.confirm;
  
  if (confirmMessage && !form.dataset.confirmed) {
    e.preventDefault();
    e.stopImmediatePropagation();
    
    // Determinar tipo de ação
    const isDelete = form.querySelector('input[name="_method"][value="delete"]') !== null;
    const type = isDelete ? 'danger' : 'warning';
    const title = isDelete ? 'Confirmar Exclusão' : 'Confirmar Alterações';
    
    showConfirmationModal(
      title,
      confirmMessage,
      type,
      function() {
        form.dataset.confirmed = 'true';
        
        // Remover o listener temporariamente para evitar loop
        const newForm = form.cloneNode(true);
        newForm.dataset.confirmed = 'true';
        form.parentNode.replaceChild(newForm, form);
        newForm.requestSubmit();
      }
    );
  }
}, { capture: true });

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
