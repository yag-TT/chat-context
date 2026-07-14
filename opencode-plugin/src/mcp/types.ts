export type RemoteMcpConfig = {
  type: 'remote';
  url: string;
  headers?: Record<string, string>;
  oauth?: false;
};

export type LocalMcpConfig = {
  type: 'local';
  command: string[];
  environment?: Record<string, string>;
  timeout?: number;
};

export type McpConfig = RemoteMcpConfig | LocalMcpConfig;
