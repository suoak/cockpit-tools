import { Page } from './navigation';

export type PlatformId = 'antigravity' | 'codex' | 'github-copilot' | 'windsurf' | 'kiro' | 'cursor' | 'gemini';

export const ALL_PLATFORM_IDS: PlatformId[] = ['antigravity', 'codex', 'github-copilot', 'windsurf', 'kiro', 'cursor', 'gemini'];

export const PLATFORM_PAGE_MAP: Record<PlatformId, Page> = {
  antigravity: 'overview',
  codex: 'codex',
  'github-copilot': 'github-copilot',
  windsurf: 'windsurf',
  kiro: 'kiro',
  cursor: 'cursor',
  gemini: 'gemini',
};
