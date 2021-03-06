--幻蝶の雄姿
function c511001031.initial_effect(c)
	--change target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c511001031.atkcon)
	e1:SetTarget(c511001031.atktg)
	e1:SetOperation(c511001031.atkop)
	c:RegisterEffect(e1)
	if not c511001031.global_check then
		c511001031.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511001031.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511001031.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511001031.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp)
end
function c511001031.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsPhantomButterfly()
end
function c511001031.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and not g:IsContains(chkc) and c511001031.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511001031.filter,tp,LOCATION_MZONE,0,1,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511001031.filter,tp,LOCATION_MZONE,0,1,1,g)
end
function c511001031.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangeAttackTarget(tc)
	end
end
