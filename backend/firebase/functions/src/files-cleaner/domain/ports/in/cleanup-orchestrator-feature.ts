export interface CleanResult { // TODO actually this is a CleanFilesResult
    deletedFiles: string[];
    errors: string[];
    totalCleaned: number;
}

export interface CleanupOrchestratorFeature {
    cleanupExpiredFiles(): Promise<CleanResult>;
}