<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Armando &amp; Betina — Casamento</title>
<link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400;0,500;1,400;1,500&family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&family=Lato:wght@300;400&display=swap" rel="stylesheet"/>
<script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-database.js"></script>
<style>
:root{
  --bg:#1C2318;--bg2:#232C1F;--bg3:#2B3626;
  --surface:#2F3C29;--surface2:#384531;
  --border:rgba(160,185,120,0.15);--border2:rgba(160,185,120,0.30);
  --gold:#C9A84C;--gold2:#E8CC88;--gold-dim:rgba(201,168,76,0.12);
  --green:#7DA85A;--green-dim:rgba(125,168,90,0.12);
  --cream:#EDE8DC;--cream2:#D5CCBA;
  --text:#E8E2D6;--muted:#8A9580;--faint:#576152;
  --red:#C26B4A;--red-dim:rgba(194,107,74,0.15);
  --blue:#6B9FD4;--blue-dim:rgba(107,159,212,0.12);
}
*{box-sizing:border-box;margin:0;padding:0;}
html{scroll-behavior:smooth;}
body{
  background:var(--bg);color:var(--text);
  font-family:'Lato',sans-serif;font-weight:400;
  min-height:100vh;line-height:1.6;
}
body::before{
  content:'';position:fixed;inset:0;
  background:
    radial-gradient(ellipse 90% 50% at 50% -10%, rgba(125,168,90,0.07) 0%, transparent 65%),
    radial-gradient(ellipse 40% 30% at 90% 90%, rgba(201,168,76,0.05) 0%, transparent 55%),
    radial-gradient(ellipse 30% 20% at 10% 70%, rgba(125,168,90,0.04) 0%, transparent 50%);
  pointer-events:none;z-index:0;
}
body::after{
  content:'';position:fixed;inset:0;
  background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.75' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E");
  pointer-events:none;z-index:999;opacity:0.35;
}

.wrap{max-width:940px;margin:0 auto;padding:3.5rem 2rem 6rem;position:relative;z-index:1;}

/* ── HERO ── */
.hero{text-align:center;margin-bottom:3rem;padding-top:1.5rem;}
.hero-ornament{
  font-family:'EB Garamond',serif;font-style:italic;
  font-size:13px;color:var(--faint);letter-spacing:14px;
  display:block;margin-bottom:1.5rem;
}
.hero-tag{
  font-family:'EB Garamond',serif;font-style:italic;
  font-size:15px;color:var(--gold);letter-spacing:3px;
  margin-bottom:0.75rem;display:block;
}
.hero-title{
  font-family:'Libre Baskerville',serif;
  font-size:clamp(36px,6vw,64px);font-weight:400;
  color:var(--cream);letter-spacing:-0.5px;line-height:1.1;
}
.hero-title span{font-family:'EB Garamond',serif;font-style:italic;color:var(--gold);}
.hero-rule{
  display:flex;align-items:center;gap:1rem;
  margin:1.5rem auto;max-width:300px;
}
.hero-rule-line{
  flex:1;height:1px;
  background:linear-gradient(90deg,transparent,var(--border2),transparent);
}
.hero-rule-center{
  display:flex;align-items:center;gap:6px;
  font-family:'EB Garamond',serif;font-style:italic;
  font-size:18px;color:var(--faint);
}
.hero-names{
  font-family:'EB Garamond',serif;font-size:26px;
  font-style:italic;color:var(--cream2);letter-spacing:1px;
}
.hero-date-tag{
  display:inline-block;margin-top:10px;
  font-size:11px;letter-spacing:2.5px;text-transform:uppercase;
  color:var(--faint);border:1px solid var(--border);
  border-radius:99px;padding:4px 16px;
}

/* ── SYNC BAR ── */
.sync-bar{
  display:flex;align-items:center;justify-content:center;
  gap:8px;font-size:12px;color:var(--muted);
  margin-bottom:2.5rem;padding:9px 0;
  border-top:1px solid var(--border);border-bottom:1px solid var(--border);
}
.sync-dot{width:7px;height:7px;border-radius:50%;background:var(--faint);transition:background 0.3s;flex-shrink:0;}
.sync-dot.online{background:var(--green);box-shadow:0 0 7px var(--green);}
.sync-dot.saving{background:var(--gold);animation:pulse 0.8s infinite;}
@keyframes pulse{0%,100%{opacity:1;}50%{opacity:0.4;}}

/* ── SUMMARY CARDS ── */
.summary{
  display:grid;grid-template-columns:repeat(3,1fr);
  border:1px solid var(--border2);border-radius:16px;
  overflow:hidden;margin-bottom:1.25rem;
}
.sum-cell{
  padding:1.75rem 1.25rem;text-align:center;
  background:var(--bg2);border-right:1px solid var(--border);
  transition:background 0.2s;position:relative;
}
.sum-cell:last-child{border-right:none;}
.sum-cell:hover{background:var(--surface);}
.sum-label{font-size:10px;letter-spacing:2px;text-transform:uppercase;color:var(--faint);margin-bottom:10px;}
.sum-val{
  font-family:'EB Garamond',serif;font-size:30px;
  font-weight:500;color:var(--cream2);
  transition:color 0.3s;
}
.sum-val.v-paid{color:var(--green);}
.sum-val.v-due{color:var(--gold);}
.sum-accent{
  display:block;width:28px;height:2px;border-radius:99px;
  margin:10px auto 0;background:var(--border);
}
.sum-cell:nth-child(2) .sum-accent{background:var(--green);opacity:0.6;}
.sum-cell:nth-child(3) .sum-accent{background:var(--gold);opacity:0.6;}

/* ── SAVINGS CARD ── */
.savings-card{
  background:var(--bg2);border:1px solid var(--border2);
  border-radius:16px;padding:1.5rem 1.75rem;margin-bottom:1.25rem;
  position:relative;overflow:hidden;
}
.savings-card::before{
  content:'';position:absolute;top:0;left:0;right:0;height:2px;
  background:linear-gradient(90deg,transparent,var(--gold),var(--gold2),var(--gold),transparent);
}
.savings-top{display:flex;align-items:center;gap:1rem;margin-bottom:1.25rem;flex-wrap:wrap;}
.savings-icon-wrap{
  width:42px;height:42px;border-radius:12px;
  background:var(--gold-dim);border:1px solid rgba(201,168,76,0.2);
  display:flex;align-items:center;justify-content:center;
  font-size:22px;flex-shrink:0;
}
.savings-titles{flex:1;}
.savings-title{
  font-family:'Libre Baskerville',serif;
  font-size:16px;font-weight:400;color:var(--cream);
}
.savings-sub{font-size:11px;color:var(--faint);margin-top:2px;}
.savings-input-wrap{
  display:flex;align-items:center;gap:8px;
  background:var(--bg3);border:1px solid var(--border2);
  border-radius:10px;padding:8px 14px;min-width:170px;
  transition:border-color 0.2s;
}
.savings-input-wrap:focus-within{border-color:var(--gold);}
.savings-prefix{
  font-family:'EB Garamond',serif;font-size:20px;
  color:var(--gold);flex-shrink:0;
}
.savings-input{
  background:transparent;border:none;outline:none;
  font-family:'EB Garamond',serif;font-size:24px;
  color:var(--gold2);width:100%;text-align:right;
}
.savings-input::-webkit-outer-spin-button,
.savings-input::-webkit-inner-spin-button{-webkit-appearance:none;}
.savings-input{-moz-appearance:textfield;}
.savings-input:focus{color:var(--cream);}
.savings-stats{
  display:flex;gap:2rem;flex-wrap:wrap;
  font-size:12px;color:var(--faint);
}
.savings-stat strong{color:var(--cream2);}

/* ── PROGRESS SECTION ── */
.progress-section{
  background:var(--bg2);border:1px solid var(--border);
  border-radius:16px;padding:1.25rem 1.5rem;
  margin-bottom:3rem;display:flex;flex-direction:column;gap:1.25rem;
}
.prog-item{}
.prog-meta{
  display:flex;justify-content:space-between;align-items:center;
  font-size:11px;color:var(--faint);margin-bottom:8px;
}
.prog-label{display:flex;align-items:center;gap:7px;}
.prog-dot{
  width:8px;height:8px;border-radius:50%;flex-shrink:0;
}
.prog-dot.green{background:var(--green);}
.prog-dot.gold{background:var(--gold);}
.prog-pct{font-weight:700;font-size:13px;}
.prog-pct.green{color:var(--green);}
.prog-pct.gold{color:var(--gold);}
.progress-track{height:7px;background:var(--surface2);border-radius:99px;overflow:hidden;}
.progress-fill{
  height:100%;border-radius:99px;
  background:var(--green);
  transition:width 0.55s cubic-bezier(0.4,0,0.2,1);
}
.progress-fill.gold-fill{
  background:linear-gradient(90deg,var(--gold),var(--gold2));
}
.prog-legend{
  display:flex;justify-content:space-between;
  font-size:10px;color:var(--faint);margin-top:5px;
  letter-spacing:0.3px;
}
.prog-divider{
  height:1px;background:var(--border);
}

/* ── SECTION BLOCK ── */
.section{margin-bottom:3rem;}
.sec-head{
  display:flex;align-items:center;gap:12px;
  margin-bottom:1.25rem;padding-bottom:12px;
  border-bottom:1px solid var(--border);
}
.sec-icon-wrap{
  width:36px;height:36px;border-radius:10px;
  background:var(--green-dim);
  display:flex;align-items:center;justify-content:center;
  font-size:18px;flex-shrink:0;
}
.sec-title-col{flex:1;}
.sec-title{
  font-family:'Libre Baskerville',serif;
  font-size:20px;font-weight:400;color:var(--cream);
}
.sec-count{font-size:11px;color:var(--faint);margin-top:1px;}
.sec-right{text-align:right;}
.sec-summary{font-size:12px;color:var(--muted);margin-bottom:4px;}
.sec-summary strong{color:var(--green);font-size:14px;}
.sec-prog-track{
  height:3px;background:var(--surface2);border-radius:99px;
  overflow:hidden;width:90px;margin-left:auto;
}
.sec-prog-fill{
  height:100%;border-radius:99px;
  background:var(--green);transition:width 0.4s;
}

/* ── TABLE ── */
.tbl{width:100%;border-collapse:collapse;table-layout:fixed;}
.tbl col.c-name{width:auto;}
.tbl col.c-num{width:118px;}
.tbl col.c-badge{width:92px;}
.tbl col.c-del{width:36px;}
.tbl th{
  font-size:10px;letter-spacing:1.8px;text-transform:uppercase;
  color:var(--faint);padding:6px 10px;text-align:left;
  border-bottom:1px solid var(--border);font-weight:400;
}
.tbl th.r{text-align:right;}
.tbl td{padding:10px 10px;border-bottom:1px solid var(--border);font-size:14px;vertical-align:middle;}
.tbl tr:last-child td{border-bottom:none;}
.tbl tbody tr:hover td{background:rgba(125,168,90,0.05);}
.tbl td.r{text-align:right;font-variant-numeric:tabular-nums;color:var(--muted);}
.tbl td.v-due{color:var(--gold)!important;}
.tbl tr.total-tr td{
  background:var(--surface)!important;
  font-family:'EB Garamond',serif;font-size:15px;font-weight:500;
  color:var(--cream)!important;border-top:1px solid var(--border2);
}

/* ── BADGES ── */
.badge{
  display:inline-flex;align-items:center;gap:5px;
  font-size:10px;padding:3px 10px;border-radius:99px;
  letter-spacing:0.5px;white-space:nowrap;
}
.badge-dot{width:5px;height:5px;border-radius:50%;flex-shrink:0;}
.b-paid{background:var(--green-dim);color:var(--green);}
.b-paid .badge-dot{background:var(--green);}
.b-partial{background:var(--gold-dim);color:var(--gold2);}
.b-partial .badge-dot{background:var(--gold);}
.b-pending{background:var(--red-dim);color:var(--red);}
.b-pending .badge-dot{background:var(--red);}
.b-empty{background:transparent;color:var(--faint);}

/* ── EDITABLE INPUTS ── */
.e-name{
  background:transparent;border:none;outline:none;
  font-family:'Lato',sans-serif;font-size:14px;
  color:var(--text);width:100%;cursor:text;
  border-bottom:1px solid transparent;
  transition:border-color 0.15s,background 0.15s;
  padding:3px 4px;border-radius:4px 4px 0 0;
}
.e-name:hover{border-bottom-color:var(--border2);}
.e-name:focus{background:var(--bg3);border-bottom-color:var(--gold);outline:none;}
.e-num{
  background:transparent;border:none;outline:none;
  font-family:'Lato',sans-serif;font-size:13px;
  color:var(--muted);width:100%;text-align:right;cursor:text;
  border-bottom:1px solid transparent;
  transition:border-color 0.15s,background 0.15s;
  padding:3px 4px;border-radius:4px 4px 0 0;
}
.e-num:hover{border-bottom-color:var(--border2);}
.e-num:focus{background:var(--bg3);border-bottom-color:var(--gold);color:var(--cream);outline:none;}
.e-num::-webkit-outer-spin-button,.e-num::-webkit-inner-spin-button{-webkit-appearance:none;}
.e-num{-moz-appearance:textfield;}

/* ── DELETE BUTTON ── */
.btn-del{
  background:none;border:none;cursor:pointer;
  color:var(--faint);font-size:18px;padding:2px 4px;
  border-radius:4px;transition:color 0.15s,background 0.15s;
  line-height:1;display:block;margin:0 auto;
}
.btn-del:hover{color:var(--red);background:var(--red-dim);}

/* ── ADD ROW ── */
.add-wrap{
  margin-top:6px;border:1px dashed var(--border2);
  border-radius:8px;overflow:hidden;transition:border-color 0.2s;
}
.add-wrap:focus-within{border-color:rgba(201,168,76,0.4);border-style:solid;}
.add-row{
  display:grid;
  grid-template-columns:1fr 110px 110px 110px 90px;
  gap:0;align-items:stretch;
}
.add-in{
  background:transparent;border:none;outline:none;
  font-family:'Lato',sans-serif;font-size:13px;
  color:var(--muted);padding:10px 10px;width:100%;
  border-right:1px solid var(--border);
}
.add-in::placeholder{color:var(--faint);}
.add-in:focus{color:var(--cream);background:rgba(43,54,38,0.5);}
.add-in.num{text-align:right;}
.btn-add{
  background:var(--surface2);color:var(--green);border:none;
  font-family:'Lato',sans-serif;font-size:12px;cursor:pointer;
  transition:background 0.15s,color 0.15s;
  letter-spacing:0.5px;padding:0 12px;
}
.btn-add:hover{background:var(--green-dim);color:var(--gold);}

/* ── DIVIDER ORNAMENT ── */
.div-ornament{
  display:flex;align-items:center;gap:1.25rem;
  text-align:center;font-family:'EB Garamond',serif;
  font-style:italic;font-size:14px;color:var(--faint);
  margin:2rem 0;letter-spacing:10px;
}
.div-ornament::before,.div-ornament::after{
  content:'';flex:1;height:1px;
  background:linear-gradient(90deg,transparent,var(--border),transparent);
}

/* ── ACTION BAR ── */
.action-bar{
  display:flex;justify-content:center;gap:12px;
  margin-top:3rem;padding-top:2rem;
  border-top:1px solid var(--border);flex-wrap:wrap;
}
.btn-main{
  padding:12px 32px;background:var(--green);color:#111;
  border:none;border-radius:99px;font-family:'Lato',sans-serif;
  font-size:13px;letter-spacing:0.5px;cursor:pointer;
  transition:background 0.15s,transform 0.1s;
}
.btn-main:hover{background:#8fc066;}
.btn-main:active{transform:scale(0.98);}
.btn-sec{
  padding:12px 24px;background:transparent;color:var(--muted);
  border:1px solid var(--border2);border-radius:99px;
  font-family:'Lato',sans-serif;font-size:13px;
  cursor:pointer;transition:all 0.15s;
}
.btn-sec:hover{background:var(--surface);color:var(--cream);}
.save-msg{text-align:center;font-size:12px;color:var(--green);margin-top:10px;min-height:16px;}

/* ── SUPPLIERS SECTION ── */
.suppliers-section{
  margin-top:4.5rem;padding-top:2.5rem;
  border-top:2px solid var(--border2);
}
.suppliers-head{
  display:flex;align-items:center;gap:14px;margin-bottom:0.5rem;
}
.supp-icon-wrap{
  width:42px;height:42px;border-radius:13px;
  background:var(--blue-dim);border:1px solid rgba(107,159,212,0.2);
  display:flex;align-items:center;justify-content:center;
  font-size:22px;flex-shrink:0;
}
.supp-head-text{}
.supp-main-title{
  font-family:'Libre Baskerville',serif;
  font-size:22px;font-weight:400;color:var(--cream);
}
.supp-main-sub{font-size:12px;color:var(--faint);margin-top:3px;}
.supp-summary-row{
  display:flex;gap:1.5rem;font-size:12px;color:var(--faint);
  margin-bottom:1.75rem;margin-top:0.75rem;
  padding:10px 16px;background:var(--bg2);
  border:1px solid var(--border);border-radius:10px;
  flex-wrap:wrap;
}
.supp-summary-row span strong{color:var(--cream2);}
.supp-grid{display:flex;flex-direction:column;gap:14px;margin-bottom:1.5rem;}

/* Supplier card */
.supp-card{
  background:var(--bg2);border:1px solid var(--border2);
  border-radius:14px;overflow:hidden;transition:border-color 0.2s;
}
.supp-card:focus-within{border-color:rgba(201,168,76,0.35);}
.supp-header{
  display:flex;align-items:center;gap:10px;
  padding:12px 16px;background:var(--surface);
  border-bottom:1px solid var(--border);cursor:pointer;
  user-select:none;
}
.supp-header-left{display:flex;align-items:center;gap:10px;flex:1;min-width:0;}
.supp-chevron{
  font-size:12px;color:var(--faint);
  transition:transform 0.25s;flex-shrink:0;
}
.supp-card.collapsed .supp-chevron{transform:rotate(-90deg);}
.supp-name-input{
  background:transparent;border:none;outline:none;
  font-family:'Libre Baskerville',serif;font-size:15px;
  color:var(--cream);flex:1;min-width:0;
  border-bottom:1px solid transparent;
  transition:border-color 0.15s;padding:2px 4px;
}
.supp-name-input:hover{border-bottom-color:var(--border2);}
.supp-name-input:focus{border-bottom-color:var(--gold);}
.supp-header-right{
  display:flex;align-items:center;gap:10px;flex-shrink:0;
}
.supp-meta-text{font-size:12px;color:var(--muted);font-variant-numeric:tabular-nums;}
.supp-meta-text.all-paid{color:var(--green);}
.supp-body{transition:all 0.25s;}
.supp-card.collapsed .supp-body{display:none;}

.supp-notes-wrap{padding:6px 16px;border-bottom:1px solid var(--border);}
.supp-notes-input{
  width:100%;background:transparent;border:none;outline:none;
  font-family:'Lato',sans-serif;font-size:12px;color:var(--muted);
  resize:none;min-height:28px;line-height:1.6;
}
.supp-notes-input::placeholder{color:var(--faint);}
.supp-notes-input:focus{color:var(--cream);}

.supp-inst-list{padding:0 16px;}
.inst-row{
  display:grid;
  grid-template-columns:18px 1fr 100px 140px 36px;
  gap:8px;align-items:center;
  padding:10px 0;border-bottom:1px solid var(--border);
}
.inst-row:last-child{border-bottom:none;}
.inst-check{
  width:15px;height:15px;accent-color:var(--green);
  cursor:pointer;flex-shrink:0;
}
.inst-label-input{
  background:transparent;border:none;outline:none;
  font-family:'Lato',sans-serif;font-size:13px;
  color:var(--text);border-bottom:1px solid transparent;
  transition:border-color 0.15s,color 0.15s;padding:2px 4px;width:100%;
}
.inst-label-input:hover{border-bottom-color:var(--border2);}
.inst-label-input:focus{border-bottom-color:var(--gold);}
.inst-label-input.is-paid{color:var(--faint);text-decoration:line-through;}
.inst-val-input{
  background:transparent;border:none;outline:none;
  font-family:'Lato',sans-serif;font-size:13px;
  color:var(--muted);text-align:right;width:100%;
  border-bottom:1px solid transparent;
  transition:border-color 0.15s;padding:2px 4px;
}
.inst-val-input:hover{border-bottom-color:var(--border2);}
.inst-val-input:focus{border-bottom-color:var(--gold);color:var(--cream);}
.inst-val-input::-webkit-outer-spin-button,
.inst-val-input::-webkit-inner-spin-button{-webkit-appearance:none;}
.inst-val-input{-moz-appearance:textfield;}
.inst-date-input{
  background:transparent;border:none;outline:none;
  font-family:'Lato',sans-serif;font-size:11px;
  color:var(--muted);width:100%;
  border-bottom:1px solid transparent;
  transition:border-color 0.15s;padding:2px 4px;cursor:pointer;
}
.inst-date-input:hover{border-bottom-color:var(--border2);}
.inst-date-input:focus{border-bottom-color:var(--gold);}
.inst-date-input::-webkit-calendar-picker-indicator{filter:invert(0.45);cursor:pointer;}
.inst-del{
  background:none;border:none;cursor:pointer;
  color:var(--faint);font-size:16px;padding:2px 4px;
  border-radius:4px;transition:color 0.15s,background 0.15s;
  line-height:1;display:block;margin:0 auto;
}
.inst-del:hover{color:var(--red);background:var(--red-dim);}

.supp-footer{
  display:flex;align-items:center;justify-content:space-between;
  padding:10px 16px;border-top:1px solid var(--border);
  flex-wrap:wrap;gap:8px;
}
.btn-add-inst{
  background:none;border:1px solid var(--border);cursor:pointer;
  font-family:'Lato',sans-serif;font-size:12px;color:var(--green);
  padding:5px 12px;border-radius:99px;transition:all 0.15s;
}
.btn-add-inst:hover{background:var(--green-dim);border-color:var(--green);color:var(--gold);}
.supp-progress-mini{
  display:flex;align-items:center;gap:8px;
  font-size:11px;color:var(--faint);
}
.supp-prog-track{
  width:70px;height:4px;background:var(--surface2);
  border-radius:99px;overflow:hidden;
}
.supp-prog-fill{height:100%;border-radius:99px;background:var(--green);transition:width 0.4s;}

/* Add supplier form */
.add-supp-wrap{
  background:var(--bg2);border:1px dashed var(--border2);
  border-radius:12px;overflow:hidden;transition:border-color 0.2s;
}
.add-supp-wrap:focus-within{border-color:rgba(201,168,76,0.4);border-style:solid;}
.add-supp-row{
  display:grid;grid-template-columns:1fr 130px 120px;
  align-items:stretch;
}
.add-supp-in{
  background:transparent;border:none;outline:none;
  font-family:'Lato',sans-serif;font-size:13px;
  color:var(--muted);padding:12px 14px;width:100%;
  border-right:1px solid var(--border);
}
.add-supp-in::placeholder{color:var(--faint);}
.add-supp-in:focus{color:var(--cream);}
.add-supp-in.num{text-align:right;}
.btn-add-supp{
  background:var(--surface2);color:var(--green);border:none;
  font-family:'Lato',sans-serif;font-size:12px;cursor:pointer;
  transition:background 0.15s,color 0.15s;
  letter-spacing:0.5px;padding:0 14px;
}
.btn-add-supp:hover{background:var(--green-dim);color:var(--gold);}

/* ── MODAL ── */
.modal-overlay{
  position:fixed;inset:0;background:rgba(8,12,7,0.93);
  z-index:1000;display:flex;align-items:center;justify-content:center;padding:1rem;
}
.modal-overlay.hidden{display:none;}
.modal{
  background:var(--bg2);border:1px solid var(--border2);
  border-radius:16px;padding:2.5rem;max-width:520px;width:100%;
}
.modal h2{font-family:'Libre Baskerville',serif;font-size:21px;font-weight:400;color:var(--cream);margin-bottom:0.5rem;}
.modal-desc{font-size:13px;color:var(--muted);margin-bottom:1.25rem;line-height:1.7;}
.modal-desc a{color:var(--gold);text-decoration:none;}
.modal-desc a:hover{text-decoration:underline;}
.modal-steps{background:var(--bg3);border-radius:10px;padding:1rem 1.25rem;margin-bottom:1.5rem;font-size:13px;color:var(--muted);line-height:2.1;}
.modal-steps b{color:var(--cream2);display:block;margin-bottom:2px;}
.modal-steps span{color:var(--gold2);}
.modal label{font-size:10px;letter-spacing:2px;text-transform:uppercase;color:var(--faint);display:block;margin-bottom:6px;}
.modal input[type=text]{width:100%;background:var(--bg3);border:1px solid var(--border2);border-radius:8px;padding:11px 14px;font-family:'Lato',sans-serif;font-size:13px;color:var(--cream);outline:none;margin-bottom:6px;}
.modal input[type=text]:focus{border-color:var(--gold);}
.modal-hint{font-size:11px;color:var(--faint);margin-bottom:1.25rem;line-height:1.5;}
.modal-actions{display:flex;gap:10px;justify-content:flex-end;margin-top:0.5rem;flex-wrap:wrap;}
.btn-offline{padding:10px 18px;background:transparent;color:var(--muted);border:1px solid var(--border);border-radius:8px;font-family:'Lato',sans-serif;font-size:13px;cursor:pointer;transition:all 0.15s;}
.btn-offline:hover{background:var(--surface);color:var(--cream);}
.btn-connect{padding:10px 22px;background:var(--green);color:#111;border:none;border-radius:8px;font-family:'Lato',sans-serif;font-size:13px;cursor:pointer;transition:background 0.15s;}
.btn-connect:hover{background:#8fc066;}
.modal-error{font-size:12px;color:var(--red);margin-top:6px;min-height:16px;}

/* ── OVERDUE WARNING ── */
.overdue-tag{
  font-size:9px;padding:1px 6px;border-radius:99px;
  background:var(--red-dim);color:var(--red);margin-left:4px;
  vertical-align:middle;
}

@media(max-width:600px){
  .wrap{padding:2rem 1rem 5rem;}
  .summary{grid-template-columns:1fr 1fr;}
  .sum-cell:last-child{grid-column:1/-1;border-right:none;border-top:1px solid var(--border);}
  .tbl col.c-num{width:80px;}
  .add-row{grid-template-columns:1fr 80px 80px;}
  .add-in.hide-mobile,.tbl .hide-mobile{display:none;}
  .savings-top{flex-direction:column;align-items:flex-start;}
  .savings-input-wrap{width:100%;}
  .inst-row{grid-template-columns:18px 1fr 80px 36px;}
  .inst-date-input{display:none;}
  .add-supp-row{grid-template-columns:1fr 100px;}
  .add-supp-in.hide-mobile{display:none;}
}
</style>
</head>
<body>

<!-- ═══════════════ MODAL ═══════════════ -->
<div class="modal-overlay" id="setup-modal">
  <div class="modal">
    <h2>🌿 Configurar sincronização</h2>
    <p class="modal-desc">Para vocês dois editarem juntos em tempo real, o portal usa o <strong>Firebase Realtime Database</strong> (gratuito). Configure uma vez e compartilhe o arquivo com sua noiva.</p>
    <div class="modal-steps">
      <b>Como obter a URL em 3 passos:</b>
      1. Acesse <span><a href="https://console.firebase.google.com" target="_blank">console.firebase.google.com</a></span> → crie um projeto<br>
      2. No menu lateral: <span>Criação → Realtime Database → Criar banco</span> → modo de teste<br>
      3. Na aba <span>"Dados"</span>, copie o link que aparece assim:<br>
      <span style="font-size:12px;word-break:break-all;">https://SEU-PROJETO-default-rtdb.firebaseio.com</span>
    </div>
    <label>Cole aqui o Database URL</label>
    <input type="text" id="fb-url-input" placeholder="https://seu-projeto-default-rtdb.firebaseio.com"/>
    <p class="modal-hint">⚠️ Lembre de ir em <strong>Regras</strong> no Firebase e trocar a expiração por <code>true</code> para não expirar em 30 dias.</p>
    <div class="modal-error" id="modal-error"></div>
    <div class="modal-actions">
      <button class="btn-offline" onclick="useOffline()">Usar só offline</button>
      <button class="btn-connect" id="btn-connect" onclick="connectFirebase()">Conectar e sincronizar</button>
    </div>
  </div>
</div>

<!-- ═══════════════ MAIN ═══════════════ -->
<div class="wrap">

  <!-- HERO -->
  <header class="hero">
    <span class="hero-ornament">✦ · · · ✦</span>
    <span class="hero-tag">Planejamento &amp; Organização</span>
    <h1 class="hero-title">Nosso <span>Casamento</span></h1>
    <div class="hero-rule">
      <div class="hero-rule-line"></div>
      <div class="hero-rule-center">✿</div>
      <div class="hero-rule-line"></div>
    </div>
    <p class="hero-names">Armando &amp; Betina</p>
    <span class="hero-date-tag">Portal de Planejamento</span>
  </header>

  <!-- SYNC BAR -->
  <div class="sync-bar">
    <div class="sync-dot" id="sync-dot"></div>
    <span id="sync-label">Aguardando conexão...</span>
  </div>

  <!-- SUMMARY CARDS -->
  <div class="summary">
    <div class="sum-cell">
      <div class="sum-label">Total previsto</div>
      <div class="sum-val" id="g-total">R$ 0</div>
      <span class="sum-accent"></span>
    </div>
    <div class="sum-cell">
      <div class="sum-label">Já pago</div>
      <div class="sum-val v-paid" id="g-paid">R$ 0</div>
      <span class="sum-accent"></span>
    </div>
    <div class="sum-cell">
      <div class="sum-label">A pagar</div>
      <div class="sum-val v-due" id="g-due">R$ 0</div>
      <span class="sum-accent"></span>
    </div>
  </div>

  <!-- SAVINGS CARD -->
  <div class="savings-card">
    <div class="savings-top">
      <div class="savings-icon-wrap">🪙</div>
      <div class="savings-titles">
        <div class="savings-title">Cofrinho do Casamento</div>
        <div class="savings-sub">Registre aqui o valor que vocês estão juntando para o evento</div>
      </div>
      <div class="savings-input-wrap">
        <span class="savings-prefix">R$</span>
        <input
          type="number"
          class="savings-input"
          id="savings-input"
          placeholder="0"
          oninput="updateSavings(this.value)"
          title="Valor juntado até agora"
        />
      </div>
    </div>
    <div class="savings-stats" id="savings-stats">
      <span>Juntado: <strong id="sav-val-disp">R$ 0</strong></span>
      <span>Total previsto: <strong id="sav-total-disp">R$ 0</strong></span>
      <span>Falta juntar: <strong id="sav-remaining-disp">R$ 0</strong></span>
    </div>
  </div>

  <!-- PROGRESS BARS -->
  <div class="progress-section">
    <!-- Bar 1: pagamentos realizados -->
    <div class="prog-item">
      <div class="prog-meta green">
        <span class="prog-label">
          <span class="prog-dot green"></span>
          Pagamentos realizados
        </span>
        <span class="prog-pct green" id="g-pct">0%</span>
      </div>
      <div class="progress-track">
        <div class="progress-fill" id="g-bar" style="width:0%"></div>
      </div>
      <div class="prog-legend">
        <span id="prog-paid-legend">Pago: R$ 0</span>
        <span id="prog-total-legend">Total: R$ 0</span>
      </div>
    </div>
    <div class="prog-divider"></div>
    <!-- Bar 2: cofrinho vs total -->
    <div class="prog-item">
      <div class="prog-meta gold">
        <span class="prog-label">
          <span class="prog-dot gold"></span>
          Valor juntado vs. total previsto
        </span>
        <span class="prog-pct gold" id="sav-pct">0%</span>
      </div>
      <div class="progress-track">
        <div class="progress-fill gold-fill" id="sav-bar" style="width:0%"></div>
      </div>
      <div class="prog-legend">
        <span id="prog-saved-legend">Juntado: R$ 0</span>
        <span id="prog-total-legend2">Total: R$ 0</span>
      </div>
    </div>
  </div>

  <!-- DYNAMIC SECTIONS (Budget categories) -->
  <div id="sections-container"></div>

  <!-- ACTION BAR -->
  <div class="action-bar">
    <button class="btn-main" onclick="saveAll()">Salvar alterações</button>
    <button class="btn-sec" onclick="exportCSV()">↓ Exportar CSV</button>
    <button class="btn-sec" onclick="openModal()">⚙ Reconfigurar sync</button>
  </div>
  <p class="save-msg" id="save-msg"></p>

  <!-- SUPPLIERS SECTION -->
  <div class="suppliers-section">
    <div class="suppliers-head">
      <div class="supp-icon-wrap">📋</div>
      <div class="supp-head-text">
        <div class="supp-main-title">Controle de Fornecedores</div>
        <div class="supp-main-sub">Organize os pagamentos e parcelas de cada fornecedor do casamento</div>
      </div>
    </div>
    <div class="supp-summary-row" id="supp-summary-row">
      <span>Fornecedores: <strong id="supp-count">0</strong></span>
      <span>Total contratado: <strong id="supp-total">R$ 0</strong></span>
      <span>Parcelas pagas: <strong id="supp-paid-count">0</strong></span>
      <span>Valor quitado: <strong id="supp-paid-val">R$ 0</strong></span>
      <span>A pagar: <strong id="supp-due-val">R$ 0</strong></span>
    </div>
    <div class="supp-grid" id="supp-grid"></div>
    <!-- Add supplier form -->
    <div class="add-supp-wrap">
      <div class="add-supp-row">
        <input class="add-supp-in" id="supp-new-name" placeholder="+ Nome do fornecedor (ex: Fotografia, Buffet...)" />
        <input class="add-supp-in num hide-mobile" type="number" id="supp-new-total" placeholder="Valor total (R$)" />
        <button class="btn-add-supp" onclick="addSupplier()">+ Adicionar</button>
      </div>
    </div>
  </div>

</div><!-- .wrap -->

<script>
/* ═══════════════════════════════════════════════
   DEFAULT DATA
═══════════════════════════════════════════════ */
const DEFAULT = [
  { key:'casamento', title:'Casamento', icon:'💍', items:[
    {id:1,name:'Local',total:3000,paid:0},
    {id:2,name:'Comida',total:0,paid:0},
    {id:3,name:'Bebida',total:0,paid:0},
    {id:4,name:'Decoração',total:0,paid:0},
    {id:5,name:'Músicos',total:0,paid:0},
    {id:6,name:'Fotografia',total:0,paid:0},
    {id:7,name:'Terno',total:0,paid:0},
    {id:8,name:'Vestido',total:0,paid:0},
    {id:9,name:'Convites',total:0,paid:0},
    {id:10,name:'Lembrancinhas',total:0,paid:0},
    {id:11,name:'Outros',total:0,paid:0},
  ]},
  { key:'lua', title:'Lua de Mel', icon:'✈', items:[
    {id:20,name:'Passagens',total:0,paid:0},
    {id:21,name:'Hospedagem',total:0,paid:0},
    {id:22,name:'Alimentação',total:0,paid:0},
    {id:23,name:'Passeios',total:0,paid:0},
    {id:24,name:'Transporte',total:0,paid:0},
    {id:25,name:'Compras',total:0,paid:0},
    {id:26,name:'Seguro Viagem',total:0,paid:0},
    {id:27,name:'Outros',total:0,paid:0},
  ]},
  { key:'mudanca', title:'Aluguel & Mudança', icon:'🏡', items:[
    {id:40,name:'Caução / Garantia',total:0,paid:0},
    {id:41,name:'IPTU',total:0,paid:0},
    {id:42,name:'Mudança',total:200,paid:0},
    {id:43,name:'Móveis',total:0,paid:0},
    {id:44,name:'Eletrodomésticos',total:0,paid:0},
    {id:45,name:'Taxas Contratuais',total:0,paid:0},
    {id:46,name:'Aluguel',total:0,paid:0},
    {id:47,name:'Condomínio',total:0,paid:0},
    {id:48,name:'Internet',total:0,paid:0},
    {id:49,name:'Luz',total:0,paid:0},
    {id:50,name:'Água',total:0,paid:0},
    {id:51,name:'Gás',total:0,paid:0},
    {id:52,name:'Outros',total:0,paid:0},
  ]}
];

let sections   = JSON.parse(JSON.stringify(DEFAULT));
let savedAmount = 0;
let suppliers   = [];
let db = null, fbRef = null;
let isOnline    = false;
let nextId      = 200;
let nextSuppId  = 1000;
let nextInstId  = 5000;
let saveTimeout = null;
let ignoreRemote = false;

/* ═══════════════════════════════════════════════
   MODAL
═══════════════════════════════════════════════ */
function openModal() {
  document.getElementById('setup-modal').classList.remove('hidden');
}
function closeModal() {
  document.getElementById('setup-modal').classList.add('hidden');
}

/* ═══════════════════════════════════════════════
   FIREBASE
═══════════════════════════════════════════════ */
function connectFirebase() {
  let url = document.getElementById('fb-url-input').value.trim();
  const errEl = document.getElementById('modal-error');
  errEl.textContent = '';
  if (url.includes('console.firebase.google.com')) {
    errEl.textContent = 'Isso é a URL do console. Copie o link dentro da aba "Dados" que começa com https:// e termina em .firebaseio.com';
    return;
  }
  if (!url) { errEl.textContent = 'Cole o Database URL antes de continuar.'; return; }
  if (!url.startsWith('http')) url = 'https://' + url;
  if (!url.includes('firebaseio.com')) { errEl.textContent = 'URL inválida. Deve conter "firebaseio.com".'; return; }
  url = url.replace(/\/$/, '');
  const btn = document.getElementById('btn-connect');
  btn.textContent = 'Conectando...'; btn.disabled = true;
  try {
    let app;
    try { app = firebase.app('wedding'); }
    catch(e) { app = firebase.initializeApp({ databaseURL: url }, 'wedding'); }
    db = firebase.database(app);
    fbRef = db.ref('dados_casamento');
    fbRef.child('_ping').set(Date.now())
      .then(() => {
        localStorage.setItem('fb_url', url);
        closeModal(); startListening();
        btn.textContent = 'Conectar e sincronizar'; btn.disabled = false;
      })
      .catch(err => {
        errEl.textContent = 'Erro ao gravar: ' + err.message;
        btn.textContent = 'Conectar e sincronizar'; btn.disabled = false;
      });
  } catch(e) {
    errEl.textContent = 'Erro: ' + e.message;
    btn.textContent = 'Conectar e sincronizar'; btn.disabled = false;
  }
}

function startListening() {
  setSyncStatus('connecting');
  fbRef.on('value', snap => {
    if (snap.exists() && !ignoreRemote) {
      const data = snap.val();
      if (data) {
        if (data.sections && Array.isArray(data.sections)) sections = data.sections;
        if (typeof data.savedAmount === 'number') savedAmount = data.savedAmount;
        if (data.suppliers && Array.isArray(data.suppliers)) suppliers = data.suppliers;
        renderAll();
      }
    }
    setSyncStatus('online');
  }, err => {
    setSyncStatus('offline');
    console.error('Firebase listen error:', err);
  });
}

function useOffline() {
  closeModal(); loadLocal();
  setSyncStatus('offline'); renderAll();
}

function setSyncStatus(state) {
  const dot = document.getElementById('sync-dot');
  const lbl = document.getElementById('sync-label');
  dot.className = 'sync-dot';
  if (state === 'online') {
    dot.classList.add('online');
    lbl.textContent = 'Sincronizado em tempo real — Armando & Betina veem as mesmas informações';
    isOnline = true;
  } else if (state === 'saving') {
    dot.classList.add('saving');
    lbl.textContent = 'Salvando...';
  } else if (state === 'connecting') {
    lbl.textContent = 'Conectando ao Firebase...';
  } else {
    lbl.textContent = 'Modo offline — dados salvos só neste navegador';
    isOnline = false;
  }
}

/* ═══════════════════════════════════════════════
   LOCAL STORAGE
═══════════════════════════════════════════════ */
function loadLocal() {
  // try new key first
  const s = localStorage.getItem('casamento_v5');
  if (s) {
    try {
      const data = JSON.parse(s);
      if (data.sections && Array.isArray(data.sections)) sections = data.sections;
      if (typeof data.savedAmount === 'number') savedAmount = data.savedAmount;
      if (data.suppliers && Array.isArray(data.suppliers)) suppliers = data.suppliers;
      return;
    } catch(e) {}
  }
  // fallback: old key
  const old = localStorage.getItem('casamento_v4');
  if (old) { try { sections = JSON.parse(old); } catch(e) {} }
}

function saveLocal() {
  localStorage.setItem('casamento_v5', JSON.stringify({ sections, savedAmount, suppliers }));
}

/* ═══════════════════════════════════════════════
   SAVE
═══════════════════════════════════════════════ */
function saveAll() {
  saveLocal();
  if (fbRef) {
    setSyncStatus('saving');
    ignoreRemote = true;
    fbRef.set({ sections, savedAmount, suppliers, _ping: Date.now() })
      .then(() => {
        setSyncStatus('online');
        showMsg('Salvo e sincronizado.');
        setTimeout(() => ignoreRemote = false, 1000);
      })
      .catch(err => {
        setSyncStatus('online');
        showMsg('Erro ao sincronizar: ' + err.message);
        ignoreRemote = false;
      });
  } else {
    showMsg('Salvo neste dispositivo.');
  }
}

function scheduleSave() {
  clearTimeout(saveTimeout);
  saveTimeout = setTimeout(() => saveAll(), 2000);
}

function showMsg(m) {
  const el = document.getElementById('save-msg');
  el.textContent = m;
  setTimeout(() => el.textContent = '', 3500);
}

/* ═══════════════════════════════════════════════
   HELPERS
═══════════════════════════════════════════════ */
function fmt(v) {
  const n = parseFloat(v) || 0;
  return 'R$ ' + n.toLocaleString('pt-BR', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
}

function badge(t, p) {
  t = parseFloat(t) || 0;
  p = parseFloat(p) || 0;
  if (t <= 0) {
    return '<span class="badge b-empty">—</span>';
  }
  if (p >= t) {
    return '<span class="badge b-paid"><span class="badge-dot"></span>Pago</span>';
  }
  if (p > 0) {
    return '<span class="badge b-partial"><span class="badge-dot"></span>Parcial</span>';
  }
  return '<span class="badge b-pending"><span class="badge-dot"></span>Pendente</span>';
}

function esc(s) {
  return String(s || '').replace(/&/g,'&amp;').replace(/"/g,'&quot;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function isOverdue(dateStr) {
  if (!dateStr) return false;
  const today = new Date(); today.setHours(0,0,0,0);
  const d = new Date(dateStr + 'T00:00:00');
  return d < today;
}

/* ═══════════════════════════════════════════════
   RENDER
═══════════════════════════════════════════════ */
function renderAll() {
  updateGlobal();
  renderSections();
  renderSuppliers();
}

function updateGlobal() {
  let gt = 0, gp = 0;
  sections.forEach(s => (s.items || []).forEach(i => {
    gt += parseFloat(i.total) || 0;
    gp += parseFloat(i.paid)  || 0;
  }));
  const due = Math.max(0, gt - gp);
  const pct = gt > 0 ? Math.min(100, Math.round((gp / gt) * 100)) : 0;

  document.getElementById('g-total').textContent = fmt(gt);
  document.getElementById('g-paid').textContent  = fmt(gp);
  document.getElementById('g-due').textContent   = fmt(due);
  document.getElementById('g-pct').textContent   = pct + '%';
  document.getElementById('g-bar').style.width   = pct + '%';
  document.getElementById('prog-paid-legend').textContent  = 'Pago: ' + fmt(gp);
  document.getElementById('prog-total-legend').textContent = 'Total: ' + fmt(gt);

  // savings bar
  const sv = parseFloat(savedAmount) || 0;
  const svPct = gt > 0 ? Math.min(100, Math.round((sv / gt) * 100)) : 0;
  document.getElementById('sav-pct').textContent   = svPct + '%';
  document.getElementById('sav-bar').style.width   = svPct + '%';
  document.getElementById('sav-val-disp').textContent       = fmt(sv);
  document.getElementById('sav-total-disp').textContent     = fmt(gt);
  document.getElementById('sav-remaining-disp').textContent = fmt(Math.max(0, gt - sv));
  document.getElementById('prog-saved-legend').textContent  = 'Juntado: ' + fmt(sv);
  document.getElementById('prog-total-legend2').textContent = 'Total: ' + fmt(gt);

  // sync savings input field value if not focused
  const sinput = document.getElementById('savings-input');
  if (sinput && document.activeElement !== sinput) {
    sinput.value = sv > 0 ? sv : '';
  }
}

function renderSections() {
  const c = document.getElementById('sections-container');
  c.innerHTML = '';
  sections.forEach((sec, si) => {
    const items = sec.items || [];
    let st = 0, sp = 0;
    items.forEach(i => {
      st += parseFloat(i.total) || 0;
      sp += parseFloat(i.paid)  || 0;
    });
    const secPct = st > 0 ? Math.min(100, Math.round((sp / st) * 100)) : 0;

    const rows = items.map((item, ii) => {
      const t = parseFloat(item.total) || 0;
      const p = parseFloat(item.paid)  || 0;
      const due = Math.max(0, t - p);
      return `<tr data-si="${si}" data-ii="${ii}">
        <td><input class="e-name" value="${esc(item.name)}" oninput="updateField(${si},${ii},'name',this.value)" title="Editar nome"/></td>
        <td class="r"><input class="e-num" type="number" value="${t || ''}" placeholder="0" oninput="updateField(${si},${ii},'total',this.value)" title="Valor total"/></td>
        <td class="r hide-mobile"><input class="e-num" type="number" value="${p || ''}" placeholder="0" oninput="updateField(${si},${ii},'paid',this.value)" title="Valor pago"/></td>
        <td class="r cell-due ${due > 0 ? 'v-due' : ''}" data-si="${si}" data-ii="${ii}">${fmt(due)}</td>
        <td class="cell-badge" style="text-align:center" data-si="${si}" data-ii="${ii}">${badge(t, p)}</td>
        <td><button class="btn-del" onclick="deleteItem(${si},${ii})" title="Remover item">×</button></td>
      </tr>`;
    }).join('');

    const div = document.createElement('div');
    div.className = 'section';
    div.innerHTML = `
      <div class="sec-head">
        <div class="sec-icon-wrap">${sec.icon}</div>
        <div class="sec-title-col">
          <div class="sec-title">
            <input class="e-name" value="${esc(sec.title)}" onchange="updateSectionTitle(${si}, this.value)" style="font-family:'Libre Baskerville',serif;font-size:20px;"/>
          </div>
          <div class="sec-count">${items.length} iten${items.length !== 1 ? 's' : ''}</div>
        </div>
        <div class="sec-right">
          <div class="sec-summary" data-si="${si}"><strong>${fmt(sp)}</strong> pago de ${fmt(st)}</div>
          <div class="sec-prog-track">
            <div class="sec-prog-fill" data-si="${si}" style="width:${secPct}%"></div>
          </div>
        </div>
      </div>
      <table class="tbl">
        <colgroup>
          <col class="c-name"/>
          <col class="c-num"/>
          <col class="c-num hide-mobile"/>
          <col class="c-num"/>
          <col class="c-badge"/>
          <col class="c-del"/>
        </colgroup>
        <thead><tr>
          <th>Item</th>
          <th class="r">Valor total</th>
          <th class="r hide-mobile">Valor pago</th>
          <th class="r">A pagar</th>
          <th style="text-align:center">Status</th>
          <th></th>
        </tr></thead>
        <tbody>
          ${rows}
          <tr class="total-tr" data-si="${si}">
            <td>Total</td>
            <td class="r sec-total-val">${fmt(st)}</td>
            <td class="r hide-mobile sec-paid-val" style="color:var(--green)!important">${fmt(sp)}</td>
            <td class="r sec-due-val" style="color:var(--gold)!important">${fmt(Math.max(0, st - sp))}</td>
            <td></td><td></td>
          </tr>
        </tbody>
      </table>
      <div class="add-wrap">
        <div class="add-row">
          <input class="add-in" id="an${si}" placeholder="+ Nome do novo item..."/>
          <input class="add-in num" type="number" id="at${si}" placeholder="Total (R$)"/>
          <input class="add-in num hide-mobile" type="number" id="ap${si}" placeholder="Pago (R$)"/>
          <input class="add-in num hide-mobile" type="number" disabled style="opacity:0;pointer-events:none"/>
          <button class="btn-add" onclick="addItem(${si})">+ Adicionar</button>
        </div>
      </div>
      ${si < sections.length - 1 ? '<div class="div-ornament">· ✦ ·</div>' : ''}
    `;
    c.appendChild(div);
  });
}

/* ═══════════════════════════════════════════════
   IN-PLACE ROW UPDATE (preserves focus while typing)
═══════════════════════════════════════════════ */
function updateRowInPlace(si, ii) {
  const item = sections[si].items[ii];
  const t = parseFloat(item.total) || 0;
  const p = parseFloat(item.paid)  || 0;
  const due = Math.max(0, t - p);

  // Update due cell
  const dueCell = document.querySelector(`.cell-due[data-si="${si}"][data-ii="${ii}"]`);
  if (dueCell) {
    dueCell.textContent = fmt(due);
    dueCell.className = `r cell-due${due > 0 ? ' v-due' : ''}`;
    dueCell.setAttribute('data-si', si);
    dueCell.setAttribute('data-ii', ii);
  }

  // Update badge cell
  const badgeCell = document.querySelector(`.cell-badge[data-si="${si}"][data-ii="${ii}"]`);
  if (badgeCell) badgeCell.innerHTML = badge(t, p);
}

function updateSectionTotalsInPlace(si) {
  const items = sections[si].items || [];
  let st = 0, sp = 0;
  items.forEach(i => {
    st += parseFloat(i.total) || 0;
    sp += parseFloat(i.paid)  || 0;
  });
  const secPct = st > 0 ? Math.min(100, Math.round((sp / st) * 100)) : 0;

  const totalRow = document.querySelector(`.total-tr[data-si="${si}"]`);
  if (totalRow) {
    const tv = totalRow.querySelector('.sec-total-val');
    const pv = totalRow.querySelector('.sec-paid-val');
    const dv = totalRow.querySelector('.sec-due-val');
    if (tv) tv.textContent = fmt(st);
    if (pv) pv.textContent = fmt(sp);
    if (dv) dv.textContent = fmt(Math.max(0, st - sp));
  }

  const summary = document.querySelector(`.sec-summary[data-si="${si}"]`);
  if (summary) summary.innerHTML = `<strong>${fmt(sp)}</strong> pago de ${fmt(st)}`;

  const progFill = document.querySelector(`.sec-prog-fill[data-si="${si}"]`);
  if (progFill) progFill.style.width = secPct + '%';
}

/* ═══════════════════════════════════════════════
   CRUD — BUDGET SECTIONS
═══════════════════════════════════════════════ */
function updateSectionTitle(si, val) {
  sections[si].title = val;
  scheduleSave();
}

function updateField(si, ii, field, val) {
  sections[si].items[ii][field] = field === 'name' ? val : (parseFloat(val) || 0);
  updateGlobal();
  updateRowInPlace(si, ii);
  updateSectionTotalsInPlace(si);
  scheduleSave();
}

function deleteItem(si, ii) {
  const name = sections[si].items[ii].name;
  if (!confirm('Remover "' + name + '"?')) return;
  sections[si].items.splice(ii, 1);
  renderAll();
  scheduleSave();
}

function addItem(si) {
  const nameEl = document.getElementById('an' + si);
  const name = nameEl.value.trim();
  if (!name) { nameEl.focus(); return; }
  const total = parseFloat(document.getElementById('at' + si).value) || 0;
  const paidEl = document.getElementById('ap' + si);
  const paid  = paidEl ? parseFloat(paidEl.value) || 0 : 0;
  sections[si].items.push({ id: ++nextId, name, total, paid });
  renderAll();
  scheduleSave();
}

/* ═══════════════════════════════════════════════
   SAVINGS
═══════════════════════════════════════════════ */
function updateSavings(val) {
  savedAmount = parseFloat(val) || 0;
  updateGlobal();
  scheduleSave();
}

/* ═══════════════════════════════════════════════
   SUPPLIERS RENDER
═══════════════════════════════════════════════ */
function renderSuppliers() {
  const grid = document.getElementById('supp-grid');
  grid.innerHTML = '';

  let totalContracted = 0, totalPaidVal = 0, totalInstPaid = 0, totalInst = 0;

  suppliers.forEach((supp, si) => {
    const insts = supp.installments || [];
    let instPaidVal = 0, instPaidCount = 0;
    insts.forEach(inst => {
      const v = parseFloat(inst.value) || 0;
      totalContracted += v;
      if (inst.paid) { instPaidVal += v; instPaidCount++; totalInstPaid++; totalPaidVal += v; }
      totalInst++;
    });
    const suppTotal = insts.reduce((a, i) => a + (parseFloat(i.value) || 0), 0);
    const suppPct = suppTotal > 0 ? Math.min(100, Math.round((instPaidVal / suppTotal) * 100)) : 0;
    const allPaid = suppTotal > 0 && instPaidVal >= suppTotal;

    const instRows = insts.map((inst, ii) => {
      const overdue = !inst.paid && isOverdue(inst.dueDate);
      return `<div class="inst-row" data-supp="${si}" data-inst="${ii}">
        <input type="checkbox" class="inst-check" ${inst.paid ? 'checked' : ''} onchange="toggleInstPaid(${si},${ii},this.checked)" title="Marcar como pago"/>
        <input class="inst-label-input ${inst.paid ? 'is-paid' : ''}" value="${esc(inst.label)}" placeholder="Descrição da parcela" oninput="updateInst(${si},${ii},'label',this.value)"/>
        <input class="inst-val-input" type="number" value="${inst.value || ''}" placeholder="R$ 0" oninput="updateInst(${si},${ii},'value',this.value)"/>
        <input class="inst-date-input" type="date" value="${inst.dueDate || ''}" oninput="updateInst(${si},${ii},'dueDate',this.value)" title="Data de vencimento"/>
        <button class="inst-del" onclick="deleteInst(${si},${ii})" title="Remover parcela">×</button>
      </div>`;
    }).join('');

    const isCollapsed = supp.collapsed || false;

    const card = document.createElement('div');
    card.className = 'supp-card' + (isCollapsed ? ' collapsed' : '');
    card.dataset.si = si;
    card.innerHTML = `
      <div class="supp-header" onclick="toggleSupplierCollapse(${si})">
        <div class="supp-header-left">
          <span class="supp-chevron">▼</span>
          <input class="supp-name-input" value="${esc(supp.name)}" placeholder="Nome do fornecedor"
            oninput="updateSupplier(${si},'name',this.value)"
            onclick="event.stopPropagation()"/>
        </div>
        <div class="supp-header-right">
          <span class="supp-meta-text ${allPaid ? 'all-paid' : ''}">${fmt(instPaidVal)} / ${fmt(suppTotal)}</span>
          <button class="btn-del" onclick="event.stopPropagation();deleteSupplier(${si})" title="Remover fornecedor">×</button>
        </div>
      </div>
      <div class="supp-body">
        <div class="supp-notes-wrap">
          <textarea class="supp-notes-input" rows="1" placeholder="Observações, contato, contrato..." oninput="updateSupplier(${si},'notes',this.value)">${esc(supp.notes || '')}</textarea>
        </div>
        <div class="supp-inst-list">
          ${insts.length > 0 ? instRows : '<div style="padding:14px 0;font-size:12px;color:var(--faint);text-align:center;">Nenhuma parcela cadastrada. Adicione abaixo.</div>'}
        </div>
        <div class="supp-footer">
          <button class="btn-add-inst" onclick="addInstallment(${si})">+ Adicionar parcela</button>
          <div class="supp-progress-mini">
            <span style="color:var(--faint)">${instPaidCount}/${insts.length} parcelas</span>
            <div class="supp-prog-track">
              <div class="supp-prog-fill" style="width:${suppPct}%"></div>
            </div>
            <span style="color:${allPaid ? 'var(--green)' : 'var(--muted)'}">${suppPct}%</span>
          </div>
        </div>
      </div>
    `;
    grid.appendChild(card);
  });

  // Update supplier summary row
  document.getElementById('supp-count').textContent     = suppliers.length;
  document.getElementById('supp-total').textContent     = fmt(totalContracted);
  document.getElementById('supp-paid-count').textContent = totalInstPaid + '/' + totalInst;
  document.getElementById('supp-paid-val').textContent  = fmt(totalPaidVal);
  document.getElementById('supp-due-val').textContent   = fmt(Math.max(0, totalContracted - totalPaidVal));
}

/* ═══════════════════════════════════════════════
   CRUD — SUPPLIERS
═══════════════════════════════════════════════ */
function toggleSupplierCollapse(si) {
  suppliers[si].collapsed = !suppliers[si].collapsed;
  const card = document.querySelector(`.supp-card[data-si="${si}"]`);
  if (card) card.classList.toggle('collapsed', suppliers[si].collapsed);
  scheduleSave();
}

function updateSupplier(si, field, val) {
  suppliers[si][field] = val;
  if (field !== 'notes') renderSuppliers();
  scheduleSave();
}

function deleteSupplier(si) {
  const name = suppliers[si].name || 'este fornecedor';
  if (!confirm('Remover "' + name + '"?')) return;
  suppliers.splice(si, 1);
  renderSuppliers();
  scheduleSave();
}

function addSupplier() {
  const nameEl = document.getElementById('supp-new-name');
  const name = nameEl.value.trim();
  if (!name) { nameEl.focus(); return; }
  const totalEl = document.getElementById('supp-new-total');
  const initialTotal = parseFloat(totalEl ? totalEl.value : 0) || 0;
  const insts = [];
  if (initialTotal > 0) {
    insts.push({ id: ++nextInstId, label: '1ª parcela', value: initialTotal, dueDate: '', paid: false });
  }
  suppliers.push({ id: ++nextSuppId, name, notes: '', installments: insts, collapsed: false });
  nameEl.value = '';
  if (totalEl) totalEl.value = '';
  renderSuppliers();
  scheduleSave();
}

function addInstallment(si) {
  const insts = suppliers[si].installments || [];
  const num = insts.length + 1;
  const ord = num === 1 ? '1ª' : num === 2 ? '2ª' : num === 3 ? '3ª' : num + 'ª';
  insts.push({ id: ++nextInstId, label: ord + ' parcela', value: 0, dueDate: '', paid: false });
  suppliers[si].installments = insts;
  renderSuppliers();
  scheduleSave();
}

function deleteInst(si, ii) {
  suppliers[si].installments.splice(ii, 1);
  renderSuppliers();
  scheduleSave();
}

function toggleInstPaid(si, ii, checked) {
  suppliers[si].installments[ii].paid = checked;
  renderSuppliers();
  scheduleSave();
}

function updateInst(si, ii, field, val) {
  suppliers[si].installments[ii][field] = field === 'value' ? (parseFloat(val) || 0) : val;
  renderSuppliers();
  scheduleSave();
}

/* ═══════════════════════════════════════════════
   EXPORT CSV
═══════════════════════════════════════════════ */
function exportCSV() {
  let csv = 'Categoria,Item,Valor Total,Valor Pago,A Pagar,Status\n';
  sections.forEach(s => {
    (s.items || []).forEach(i => {
      const t = parseFloat(i.total) || 0;
      const p = parseFloat(i.paid)  || 0;
      const st = t <= 0 ? '—' : p >= t ? 'Pago' : p > 0 ? 'Parcial' : 'Pendente';
      csv += `"${s.title}","${i.name}",${t},${p},${Math.max(0, t - p)},"${st}"\n`;
    });
  });
  csv += '\nFornecedor,Parcela,Valor,Vencimento,Pago\n';
  suppliers.forEach(s => {
    (s.installments || []).forEach(inst => {
      csv += `"${s.name}","${inst.label}",${inst.value || 0},"${inst.dueDate || ''}","${inst.paid ? 'Sim' : 'Não'}"\n`;
    });
  });
  const blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8;' });
  const url  = URL.createObjectURL(blob);
  const a    = document.createElement('a');
  a.href = url; a.download = 'casamento-armando-betina.csv'; a.click();
  URL.revokeObjectURL(url);
}

/* ═══════════════════════════════════════════════
   KEYBOARD — Enter on add rows
═══════════════════════════════════════════════ */
document.addEventListener('keydown', e => {
  if (e.key !== 'Enter') return;
  const row = e.target.closest('.add-row');
  if (row) {
    const all = Array.from(document.querySelectorAll('.add-row'));
    const si = all.indexOf(row);
    if (si >= 0) addItem(si);
    return;
  }
  if (e.target.id === 'supp-new-name' || e.target.id === 'supp-new-total') {
    addSupplier();
  }
});

/* ═══════════════════════════════════════════════
   INIT
═══════════════════════════════════════════════ */
renderAll();

const savedUrl = localStorage.getItem('fb_url');
if (savedUrl) {
  document.getElementById('fb-url-input').value = savedUrl;
  document.getElementById('setup-modal').classList.add('hidden');
  try {
    let app;
    try { app = firebase.app('wedding'); }
    catch(e) { app = firebase.initializeApp({ databaseURL: savedUrl }, 'wedding'); }
    db = firebase.database(app);
    fbRef = db.ref('dados_casamento');
    startListening();
  } catch(e) {
    setSyncStatus('offline');
    loadLocal();
    renderAll();
  }
} else {
  loadLocal();
  renderAll();
}
</script>
</body>
</html>
