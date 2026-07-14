import { isRecord } from './guards';

export const SLIM_INTERNAL_INITIATOR_MARKER =
  '<!-- SLIM_INTERNAL_INITIATOR -->';

export const INTERNAL_INITIATOR_METADATA_KEY =
  'opencode-multi-agent.internalInitiator';

export function createInternalAgentTextPart(text: string): {
  type: 'text';
  text: string;
  synthetic: true;
  metadata: { 'opencode-multi-agent.internalInitiator': true };
} {
  return {
    type: 'text',
    synthetic: true,
    text: `${text}\n${SLIM_INTERNAL_INITIATOR_MARKER}`,
    metadata: { [INTERNAL_INITIATOR_METADATA_KEY]: true },
  } as const;
}

export function isInternalInitiatorPart(part: unknown): boolean {
  if (!isRecord(part) || part.type !== 'text') {
    return false;
  }

  if (part.synthetic !== true || !isRecord(part.metadata)) {
    return false;
  }

  return part.metadata[INTERNAL_INITIATOR_METADATA_KEY] === true;
}
