module ApplicationHelper
  def can_manage_pastorals?(user)
    return false unless user
    
    general_pastoral = Pastoral.where("LOWER(name) = ?", "geral").first
    return false unless general_pastoral
    
    general_pastoral.coordinator_id == user.id || general_pastoral.vice_coordinator_id == user.id
  end

  def can_edit_pastoral?(user, pastoral)
    return false unless user && pastoral
    
    # Coordenador ou vice-coordenador da pastoral Geral pode editar todas as pastorais
    general_pastoral = Pastoral.where("LOWER(name) = ?", "geral").first
    if general_pastoral && (general_pastoral.coordinator_id == user.id || general_pastoral.vice_coordinator_id == user.id)
      return true
    end
    
    # Coordenador ou vice-coordenador da própria pastoral pode editar
    pastoral.coordinator_id == user.id || pastoral.vice_coordinator_id == user.id
  end

  def can_delete_pastoral?(user)
    # Apenas coordenadores/vice da pastoral Geral podem excluir
    can_manage_pastorals?(user)
  end

  def can_view_liturgia_statistics?(user, pastoral)
    return false unless user && pastoral
    return false unless pastoral.name.downcase == "liturgia"
    
    # Coordenadores e vices da pastoral Geral
    general_pastoral = Pastoral.where("LOWER(name) = ?", "geral").first
    if general_pastoral && (general_pastoral.coordinator_id == user.id || general_pastoral.vice_coordinator_id == user.id)
      return true
    end
    
    # Coordenadores e vices da própria pastoral Liturgia
    pastoral.coordinator_id == user.id || pastoral.vice_coordinator_id == user.id
  end
end
