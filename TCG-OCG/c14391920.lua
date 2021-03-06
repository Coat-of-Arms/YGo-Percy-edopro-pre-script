--ヘル・テンペスト
function c14391920.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c14391920.condition)
	e1:SetTarget(c14391920.target)
	e1:SetOperation(c14391920.activate)
	c:RegisterEffect(e1)
end
function c14391920.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=3000
end
function c14391920.filter(c)
	if not c:IsType(TYPE_MONSTER) or not c:IsAbleToRemove() then return false end
	if c:IsLocation(LOCATION_DECK) then return true end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c14391920.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14391920.filter,tp,LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	local sg=Duel.GetMatchingGroup(c14391920.filter,tp,LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c14391920.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c14391920.filter,tp,LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
