import { auth } from "/member/firebase-config.js?v=20260717-2";
import { onAuthStateChanged,signOut } from "https://www.gstatic.com/firebasejs/10.14.1/firebase-auth.js";

function labelFromUser(user){
  return user?.displayName||user?.email||"회원";
}

function escapeHtml(value){
  return String(value).replace(/[&<>"']/g,(ch)=>({
    "&":"&amp;",
    "<":"&lt;",
    ">":"&gt;",
    '"':"&quot;",
    "'":"&#39;"
  }[ch]));
}

function renderLoggedOut(actions){
  actions.innerHTML='<a href="/member/join.html" class="btn-nav-primary">회원가입</a><a href="/member/login.html" class="btn-nav-primary secondary">로그인</a>';
}

function renderLoggedIn(actions,user){
  const label=labelFromUser(user);
  const safeLabel=escapeHtml(label);
  actions.innerHTML=[
    '<span class="member-auth-status" style="font-size:.84rem;font-weight:700;color:#1b3a6b;max-width:170px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis" title="'+safeLabel+'">'+safeLabel+'님</span>',
    '<a href="/member/mypage.html" class="btn-nav-primary secondary">마이페이지</a>',
    '<button type="button" id="memberLogoutBtn" class="btn-nav-primary" style="border:0;background:#5a6a7e">로그아웃</button>'
  ].join("");
  const logoutBtn=actions.querySelector("#memberLogoutBtn");
  logoutBtn?.addEventListener("click",async()=>{
    logoutBtn.disabled=true;
    logoutBtn.textContent="로그아웃 중...";
    await signOut(auth);
    window.location.href="/";
  });
}

async function initAuthNav(){
  const actions=document.querySelector("#site-nav .nav-actions");
  if(!actions)return;
  onAuthStateChanged(auth,(user)=>{
    if(user?.emailVerified)renderLoggedIn(actions,user);
    else renderLoggedOut(actions);
  });
}

initAuthNav();
