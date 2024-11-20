export interface CleanResult {
    deletedFiles: string[];
    fileLinkWithUser: { [fileUid: string]: string[] };
    errors: string[];
    totalCleaned: number;
}

export interface CleanFilesFeature {
    cleanExpiredFiles(): Promise<CleanResult>;
}