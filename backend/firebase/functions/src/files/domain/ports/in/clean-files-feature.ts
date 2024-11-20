export interface CleanResult {
    deletedFiles: string[];
    errors: string[];
    totalCleaned: number;
}

export interface CleanFilesFeature {
    cleanExpiredFiles(): Promise<CleanResult>;
}