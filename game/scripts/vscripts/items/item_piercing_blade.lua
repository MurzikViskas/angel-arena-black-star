item_piercing_blade = {
	GetIntrinsicModifierName = function() return "modifier_item_piercing_blade" end
}


LinkLuaModifier("modifier_item_piercing_blade", "items/item_piercing_blade.lua", LUA_MODIFIER_MOTION_NONE)
modifier_item_piercing_blade = {
	IsHidden      = function() return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
	IsPurgable    = function() return false end,
}

function modifier_item_piercing_blade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_item_piercing_blade:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

if IsServer() then
	function modifier_item_piercing_blade:OnTakeDamage(keys)
		local attacker = keys.attacker
		if attacker ~= self:GetParent() then return end
		if keys.damage_type ~= DAMAGE_TYPE_PHYSICAL or keys.inflictor then return end

		local ability = self:GetAbility()
		ApplyDamage({
			victim = keys.unit,
			attacker = attacker,
			damage = keys.original_damage * ability:GetSpecialValueFor("attack_damage_to_pure_pct") * 0.01,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		})
	end
end
